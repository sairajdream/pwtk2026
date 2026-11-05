#!/bin/bash

# Define color variables
RED='\033[31m'
GREEN='\033[32m'
WHITE='\033[97m'
RESET='\033[0m'

# Function to print information using awk
extract_info() {
    local pattern="$1"
    local position="$2"
    local header="$3"
    local color="$4"
    echo -e "${WHITE}-----------------------------------------------${RESET}"
    echo -e "${WHITE}$header${RESET}"
    echo -e "${WHITE}-----------------------------------------------${RESET}"
    awk -v pos="$position" -v color="$color" 'BEGIN {OFS="\t"} /'"$pattern"'/ {printf color "%-30s : %s\n" "'$RESET'", FILENAME, $pos}' *.out
}

# Basic Information
echo -e "${GREEN}-----------------------------------------------${GREEN}"
echo -e "${GREEN}Filename\t\t\tcalculation${GREEN}"
echo -e "${GREEN}-----------------------------------------------${GREEN}"
awk -v color="$GREEN" 'BEGIN {OFS="\t"} /calculation/ {printf color "%-30s : %s\n" "'$RESET'", FILENAME, $3}' *.in

extract_info "PWSCF v." 3 "Filename\t\t\tQE-Vrsn" "$RED"

# Cell-related Information
extract_info "lattice parameter" 5 "Filename\t\t\tAlat" "$RED"
extract_info "unit-cell volume" 4 "Filename\t\t\tVolum" "$RED"
extract_info "number of atoms" 5 "Filename\t\t\tAtoms/cell" "$RED"

# Electronic Properties
extract_info "number of electrons" 5 "Filename\t\t\tElectrons" "$RED"
extract_info "Kohn-Sham states" 5 "Filename\t\t\tKS-States" "$RED"
extract_info "kinetic-energy cutoff" 4 "Filename\t\t\tEcut" "$RED"
extract_info "charge density cutoff" 5 "Filename\t\t\tEcutrho" "$RED"
extract_info "scf convergence threshold" 5 "Filename\t\t\tConvergence" "$RED"
extract_info "mixing beta" 4 "Filename\t\t\tMixing_beta" "$RED"
extract_info "Dispersion Correction" 1 "Filename\t\t\tvdv_corr" "$RED"
extract_info "number of k points" 5 "Filename\t\t\tK-points" "$RED"

# Final Energy
extract_info "Final energy" 4 "Filename\t\t\tFinal-energy" "$GREEN"

# Magnetization and Walltime
echo -e "${WHITE}-----------------------------------------------${RESET}"
echo -e "${WHITE}Filename\t\t\tMagnetization${RESET}"
echo -e "${WHITE}-----------------------------------------------${RESET}"
for file in *.out; do 
    tac "$file" | awk -v fname="$file" -v color="$RED" '/total magnetization/ {printf color "%-30s : %s\n" "'$RESET'", fname, $4; exit}'
done

echo -e "${WHITE}-----------------------------------------------${RESET}"
echo -e "${WHITE}Filename\t\t\tWalltime${RESET}"
echo -e "${WHITE}-----------------------------------------------${RESET}"
for file in *.out; do 
    tac "$file" | awk -v fname="$file" -v color="$RED" '/WALL/ {printf color "%-30s : %s\n" "'$RESET'", fname, $5; exit}'
done

# Pseudo Information
echo -e "${WHITE}-----------------------------------------------${RESET}"
echo -e "${WHITE}Filename\t\t\tPseudo${RESET}"
echo -e "${WHITE}-----------------------------------------------${RESET}"
awk -v color="$RED" 'BEGIN {OFS="\t"} /UPF: wavefunction/ {printf color "%-30s : %s\n" "'$RESET'", FILENAME, $2} FNR==1 && NR!=1 {print ""}' *.out

