#!/usr/bin/env bash
set -u

# ================== COLORS ==================
RESET="\033[0m"
BOLD="\033[1m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
CYAN="\033[36m"

if [[ ! -t 1 ]]; then
  RESET="" BOLD="" RED="" GREEN="" YELLOW="" BLUE="" CYAN=""
fi

# ================== DEPENDENCIES ==================
command -v docker >/dev/null 2>&1 || { echo "docker not found"; exit 1; }
command -v bc >/dev/null 2>&1 || { echo "bc not found"; exit 1; }
command -v find >/dev/null 2>&1 || { echo "find not found"; exit 1; }

# ================== ARGS ==================
TARGET_DIR="${1:-}"
shift || true
RAW_ARGS=("$@")

[[ -z "$TARGET_DIR" ]] && { echo "Usage: docker-actions <dir> <docker compose args>"; exit 1; }

ROOT_DIR="$(realpath "$TARGET_DIR" 2>/dev/null)" || {
  echo "Invalid directory: $TARGET_DIR"
  exit 1
}

[[ "$ROOT_DIR" == "/" ]] && { echo "Refusing to operate on /"; exit 1; }

# ================== FLAGS ==================
DRY_RUN=false
JSON=false
COMPOSE_ARGS=()

for arg in "${RAW_ARGS[@]}"; do
  case "$arg" in
    --dry-run) DRY_RUN=true ;;
    --json) JSON=true ;;
    *) COMPOSE_ARGS+=("$arg") ;;
  esac
done

[[ ${#COMPOSE_ARGS[@]} -eq 0 ]] && { echo "Missing docker compose args"; exit 1; }
[[ "${COMPOSE_ARGS[0]}" == "status" ]] && COMPOSE_ARGS=("ps")

# ================== HEADER ==================
if [[ "$JSON" == false ]]; then
  echo -e "${BOLD}${CYAN}Docker Compose Control${RESET}"
  echo -e "${YELLOW}Target dir${RESET}  : ${ROOT_DIR}"
  echo -e "${YELLOW}Command${RESET}     : docker compose ${COMPOSE_ARGS[*]}"
  [[ "$DRY_RUN" == true ]] && echo -e "${YELLOW}Mode${RESET}        : DRY RUN"
  echo -e "${CYAN}------------------------------------------------------------${RESET}"
fi

# ================== STATE ==================
RESULTS=()
SUCCESS_SERVICES=()
FAILED_SERVICES=()
FAILED=false

# ================== DISCOVER SERVICES (CORRECT PRUNE) ==================
mapfile -t SERVICE_DIRS < <(
  find "$ROOT_DIR" \
    -type d -exec test -f '{}/.docker-actions-ignore' \; -prune -o \
    -type f \( -name "compose.yml" -o -name "docker-compose.yml" \) -print |
  xargs -n1 dirname |
  sort -u
)

# ================== EXECUTE ==================
for dir in "${SERVICE_DIRS[@]}"; do
  service_name="$(basename "$dir")"

  compose_file=""
  [[ -f "$dir/compose.yml" ]] && compose_file="$dir/compose.yml"
  [[ -f "$dir/docker-compose.yml" ]] && compose_file="$dir/docker-compose.yml"
  [[ -z "$compose_file" ]] && continue

  start=$(date +%s.%N)

  if [[ "$JSON" == false ]]; then
    echo
    echo -e "${BOLD}${BLUE}>>> Service:${RESET} ${service_name}"
    echo -e "${CYAN}    Compose:${RESET} ${compose_file}"
    echo
  fi

  if [[ "$DRY_RUN" == true ]]; then
    RESULTS+=("{\"service\":\"$service_name\",\"status\":\"dry-run\"}")
    SUCCESS_SERVICES+=("$service_name")
    continue
  fi

  (
    cd "$dir" || exit 1
    docker compose --ansi=always "${COMPOSE_ARGS[@]}"
  )

  rc=$?
  end=$(date +%s.%N)
  duration=$(printf "%.2f" "$(echo "$end - $start" | bc)")

  if [[ $rc -eq 0 ]]; then
    RESULTS+=("{\"service\":\"$service_name\",\"status\":\"success\",\"duration\":$duration}")
    SUCCESS_SERVICES+=("$service_name")
    [[ "$JSON" == false ]] && echo -e "${GREEN}    Status : SUCCESS${RESET} (${duration}s)"
  else
    FAILED=true
    RESULTS+=("{\"service\":\"$service_name\",\"status\":\"failed\",\"duration\":$duration}")
    FAILED_SERVICES+=("$service_name")
    [[ "$JSON" == false ]] && echo -e "${RED}    Status : FAILED${RESET} (${duration}s)"
  fi
done

# ================== SUMMARY ==================
if [[ "$JSON" == false ]]; then
  echo
  echo -e "${BOLD}${CYAN}============================================================${RESET}"
  echo -e "${BOLD}SUMMARY${RESET}"
  echo -e "${CYAN}------------------------------------------------------------${RESET}"

  echo -e "${GREEN}Successful (${#SUCCESS_SERVICES[@]}):${RESET}"
  for s in "${SUCCESS_SERVICES[@]}"; do
    echo -e "  ${GREEN}✓${RESET} $s"
  done

  echo
  echo -e "${RED}Failed (${#FAILED_SERVICES[@]}):${RESET}"
  for f in "${FAILED_SERVICES[@]}"; do
    echo -e "  ${RED}✗${RESET} $f"
  done

  echo -e "${CYAN}============================================================${RESET}"
fi

# ================== JSON ==================
if [[ "$JSON" == true ]]; then
  echo "{"
  echo "  \"target\": \"${ROOT_DIR}\","
  echo "  \"command\": \"docker compose ${COMPOSE_ARGS[*]}\","
  echo "  \"results\": ["
  printf "    %s,\n" "${RESULTS[@]}" | sed '$ s/,$//'
  echo "  ]"
  echo "}"
fi

$FAILED && exit 1 || exit 0
