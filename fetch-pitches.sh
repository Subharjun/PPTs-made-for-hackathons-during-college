#!/bin/bash

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# GitHub raw URL prefix for the repository
REPO_RAW_URL="https://raw.githubusercontent.com/Subharjun/PPTs-made-for-hackathons-during-college/main"

# Array of presentations (URL encoded spaces to %20)
declare -A PRESENTATIONS=(
    ["AI-Career-Mentor"]="AI-Career-Mentor-Your-Path-to-Success%20(3).pptx"
    ["Educ-A-Thon"]="Educ-A-Thon%202.0-LastHope.ppt"
    ["GDG-TechSprint"]="GDG%20on%20Campus%20TMSL-%20TechSprint%20LastHope.pptx"
    ["HackXios"]="HackXios%202k25%20PPT%20Template.pptx"
    ["Hackspire"]="Hackspire_PPT.pptx"
    ["Mobilothon"]="Idea%20Submission%20Deck%20_%20i.Mobilothon%205.0.pptx"
    ["SBH-2025"]="SBH-2025_donedeal.pptx"
    ["SIH-Career_Mentor"]="SIH2025-IDEA-25094-Career-Mentor.pdf"
    ["SIH-Village_Gentle"]="SIH2025-IDEA-Presentation-25010-Village-Gentle.pdf"
    ["Technocrats"]="Technocrats%20Hackathon-PPT.pptx"
    ["IMI-Hackathon"]="imi%20hackathon.pptx"
)

# Function to print the banner
print_banner() {
    clear
    echo -e "${CYAN}"
    echo "  ___         _   _               _                ___  _  _       _"
    echo " | _ \ __  _ | |_| |_  ___  _ _  (_) ___  __ __  | _ \(_)| |_  __ | |"
    echo " |  _// _| | |_|  _ \ / _ \| ' \ | |/ _ \ \ V /  |  _/| ||  _|/ _||  _|"
    echo " |_|  \__| |_| |_| \_|\___/|_||_||_|\___/  \_/   |_|  |_| \__|\__||_|"
    echo
    echo -e "${YELLOW}        📚 A collection of winning ideas and pitch decks 📚"
    echo -e "${NC}"
}

# Function to download a specific presentation
download_file() {
    local name=$1
    local filename=${PRESENTATIONS[$name]}
    local url="${REPO_RAW_URL}/${filename}"

    # Decode filename back to spaces for saving
    local save_as="${filename//%20/ }"

    echo -e "${BLUE}[*] Fetching ${save_as}...${NC}"

    if command -v wget >/dev/null 2>&1; then
        wget -q --show-progress -O "$save_as" "$url"
    elif command -v curl >/dev/null 2>&1; then
        curl -L -# -o "$save_as" "$url"
    else
        echo -e "${RED}[!] Error: Neither curl nor wget is installed.${NC}"
        exit 1
    fi

    echo -e "${GREEN}[✔] Download complete: ${save_as}${NC}"
}

# Function to show menu
show_menu() {
    echo -e "${YELLOW}Available Presentations:${NC}"
    echo
    local i=1
    local keys=("${!PRESENTATIONS[@]}")

    for key in "${keys[@]}"; do
        echo -e "  ${CYAN}[$i]${NC} $key"
        ((i++))
    done
    echo
    echo -e "  ${CYAN}[A]${NC} Download ALL Presentations"
    echo -e "  ${CYAN}[Q]${NC} Quit"
    echo

    read -p "Select a presentation to download (1-$((i-1)), A, or Q): " choice

    if [[ "$choice" == "q" || "$choice" == "Q" ]]; then
        echo -e "${GREEN}Goodbye! Keep hacking! 🚀${NC}"
        exit 0
    elif [[ "$choice" == "a" || "$choice" == "A" ]]; then
        echo -e "${BLUE}Downloading all presentations...${NC}"
        for key in "${keys[@]}"; do
            download_file "$key"
            echo
        done
        echo -e "${GREEN}All presentations downloaded successfully! 📁${NC}"
    elif [[ "$choice" =~ ^[0-9]+$ ]] && [[ "$choice" -ge 1 ]] && [[ "$choice" -le $((i-1)) ]]; then
        local selected_key="${keys[$((choice-1))]}"
        download_file "$selected_key"
    else
        echo -e "${RED}Invalid choice. Please try again.${NC}"
        sleep 2
        main
    fi
}

main() {
    print_banner
    show_menu
}

# Run the script
main
