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

# ---------- Args ----------
TARGET_DIR="${1:-}"
COMPOSE_ARGS=("${@:2}")

SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"

# Resolve root directory:
# - "."  → current working directory
# - else → use path as provided (relative or absolute)
if [[ "$TARGET_DIR" == "." ]]; then
  ROOT_DIR="$(pwd)"
else
  ROOT_DIR="$TARGET_DIR"
fi

# ---------- Validation ----------
if [[ -z "$TARGET_DIR" ]]; then
  echo -e "${RED}Usage:${RESET} docker-actions <directory> <docker compose args>"
  exit 1
fi

if [[ ${#COMPOSE_ARGS[@]} -eq 0 ]]; then
  echo -e "${RED}Error:${RESET} missing docker compose arguments"
  echo "Example: docker-actions apps up -d"
  exit 1
fi

if [[ ! -d "$ROOT_DIR" ]]; then
  echo -e "${RED}Error:${RESET} directory '$ROOT_DIR' does not exist"
  exit 1
fi

# ---------- Header ----------
echo -e "${BOLD}${CYAN}Docker Compose Control${RESET}"
echo -e "${YELLOW}Target dir${RESET}  : ${ROOT_DIR}"
echo -e "${YELLOW}Command${RESET}     : docker compose ${COMPOSE_ARGS[*]}"
echo -e "${CYAN}------------------------------------------------------------${RESET}"

SUCCESS=()
FAILED=()

# ---------- Core Logic ----------
run_service() {
  local dir="$1"

  local compose_file=""
  if [[ -f "$dir/compose.yml" ]]; then
    compose_file="$dir/compose.yml"
  elif [[ -f "$dir/docker-compose.yml" ]]; then
    compose_file="$dir/docker-compose.yml"
  fi

  # If a compose file exists here, run it and stop descending
  if [[ -n "$compose_file" ]]; then
    local service_name
    service_name="$(realpath --relative-to="$SCRIPT_DIR" "$dir" 2>/dev/null || echo "$dir")"

    echo
    echo -e "${BOLD}${BLUE}>>> Service:${RESET} ${service_name}"
    echo -e "${CYAN}    Compose:${RESET} ${compose_file}"

    (
      cd "$dir" || exit 1
      docker compose "${COMPOSE_ARGS[@]}"
    )

    if [[ $? -eq 0 ]]; then
      echo -e "${GREEN}    Status : SUCCESS${RESET}"
      SUCCESS+=("$service_name")
    else
      echo -e "${RED}    Status : FAILED${RESET}"
      FAILED+=("$service_name")
    fi

    return 0
  fi

  # Otherwise, recurse into subdirectories
  for subdir in "$dir"/*/; do
    [[ -d "$subdir" ]] || continue
    run_service "$subdir"
  done
}

run_service "$ROOT_DIR"

# ---------- Summary ----------
echo
echo -e "${BOLD}${CYAN}==================== SUMMARY ====================${RESET}"

echo -e "${GREEN}Successful : ${#SUCCESS[@]}${RESET}"
for s in "${SUCCESS[@]}"; do
  echo -e "  ${GREEN}- ${s}${RESET}"
done

echo
echo -e "${RED}Failed     : ${#FAILED[@]}${RESET}"
for f in "${FAILED[@]}"; do
  echo -e "  ${RED}- ${f}${RESET}"
done

echo -e "${CYAN}=================================================${RESET}"

if [[ ${#FAILED[@]} -ne 0 ]]; then
  exit 1
fi

