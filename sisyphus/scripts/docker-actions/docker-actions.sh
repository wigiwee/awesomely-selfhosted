#!/usr/bin/env bash

set -u

# ---------- Colors ----------
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

# ---------- Args ----------
TARGET_DIR="${1:-}"
RAW_ARGS=("${@:2}")

if [[ -z "$TARGET_DIR" ]]; then
  echo "Usage: docker-actions <directory> <docker compose args>"
  exit 1
fi

if ! ROOT_DIR="$(realpath "$TARGET_DIR" 2>/dev/null)"; then
  echo "Invalid directory: $TARGET_DIR"
  exit 1
fi

[[ "$ROOT_DIR" == "/" ]] && echo "Refusing to operate on /" && exit 1

# ---------- Flags ----------
DRY_RUN=false
PARALLEL=false
JSON=false
COMPOSE_ARGS=()

for arg in "${RAW_ARGS[@]}"; do
  case "$arg" in
    --dry-run) DRY_RUN=true ;;
    --parallel) PARALLEL=true ;;
    --json) JSON=true ;;
    *) COMPOSE_ARGS+=("$arg") ;;
  esac
done

[[ ${#COMPOSE_ARGS[@]} -eq 0 ]] && echo "Missing docker compose arguments" && exit 1
[[ "${COMPOSE_ARGS[0]}" == "status" ]] && COMPOSE_ARGS=("ps")

# ---------- Header ----------
if [[ "$JSON" == false ]]; then
  echo -e "${BOLD}${CYAN}Docker Compose Control${RESET}"
  echo -e "${YELLOW}Target dir${RESET}  : ${ROOT_DIR}"
  echo -e "${YELLOW}Command${RESET}     : docker compose ${COMPOSE_ARGS[*]}"
  [[ "$DRY_RUN" == true ]] && echo -e "${YELLOW}Mode${RESET}        : DRY RUN"
  echo -e "${CYAN}------------------------------------------------------------${RESET}"
fi

RESULTS=()
SUCCESS_SERVICES=()
FAILED_SERVICES=()
FAILED=false

# ---------- Core Logic ----------
run_service() {
  local dir="$1"

  [[ -f "$dir/.docker-actions-ignore" ]] && return

  local compose_file=""
  [[ -f "$dir/compose.yml" ]] && compose_file="$dir/compose.yml"
  [[ -f "$dir/docker-compose.yml" ]] && compose_file="$dir/docker-compose.yml"

  if [[ -z "$compose_file" ]]; then
    for d in "$dir"/*/; do [[ -d "$d" ]] && run_service "$d"; done
    return
  fi

  local service_name start end duration rc
  service_name="$(basename "$dir")"
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
    return
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
}

# ---------- Execution ----------
if [[ "$PARALLEL" == true ]]; then
  for d in "$ROOT_DIR"/*/; do [[ -d "$d" ]] && run_service "$d" & done
  wait
else
  run_service "$ROOT_DIR"
fi

# ---------- Summary ----------
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

# ---------- JSON Output ----------
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

