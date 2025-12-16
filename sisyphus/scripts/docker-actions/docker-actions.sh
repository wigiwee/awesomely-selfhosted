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
ACTION="${2:-}"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$SCRIPT_DIR/$TARGET_DIR"

# ---------- Validation ----------
if [[ -z "$TARGET_DIR" || -z "$ACTION" ]]; then
  echo -e "${RED}Usage:${RESET} $0 <directory> {up|down}"
  exit 1
fi

if [[ ! -d "$ROOT_DIR" ]]; then
  echo -e "${RED}Error:${RESET} directory '$TARGET_DIR' does not exist"
  exit 1
fi

if [[ "$ACTION" != "up" && "$ACTION" != "down" ]]; then
  echo -e "${RED}Error:${RESET} action must be 'up' or 'down'"
  exit 1
fi

# ---------- Header ----------
echo -e "${BOLD}${CYAN}Docker Compose Control${RESET}"
echo -e "${YELLOW}Target dir${RESET}  : ${ROOT_DIR}"
echo -e "${YELLOW}Action${RESET}      : docker compose ${ACTION}"
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

  if [[ -n "$compose_file" ]]; then
    local service_name
    service_name="$(realpath --relative-to="$SCRIPT_DIR" "$dir")"

    echo
    echo -e "${BOLD}${BLUE}>>> Service:${RESET} ${service_name}"
    echo -e "${CYAN}    Compose:${RESET} ${compose_file}"

    (
      cd "$dir" || exit 1
      if [[ "$ACTION" == "up" ]]; then
        docker compose up -d
      else
        docker compose down
      fi
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

