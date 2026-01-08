#!/bin/bash

# Test script to demonstrate responsive behavior
# This shows what padding values would be calculated for different terminal sizes

echo "🧪 Gazisiber-Fetch Responsive Padding Test"
echo "==========================================="
echo ""

# Simulate different terminal sizes
test_sizes=(
    "160 50 Very Wide Terminal"
    "130 40 Wide Terminal"
    "110 35 Medium-Wide Terminal"
    "90 30 Standard Terminal"
    "70 25 Narrow Terminal"
)

# The calculate_padding function from fetch.sh
calculate_padding() {
    local cols=$1
    local lines=$2
    
    local top=0
    local left=2
    local right=4
    
    if [ $cols -ge 150 ]; then
        left=4
        right=8
    elif [ $cols -ge 120 ]; then
        left=3
        right=6
    elif [ $cols -ge 100 ]; then
        left=2
        right=5
    elif [ $cols -ge 80 ]; then
        left=2
        right=4
    else
        left=1
        right=2
    fi
    
    if [ $lines -ge 40 ]; then
        top=2
    elif [ $lines -ge 30 ]; then
        top=1
    else
        top=0
    fi
    
    echo "$top $left $right"
}

echo "Terminal Size         | Top | Left | Right | Visual Balance"
echo "--------------------- |-----|------|-------|---------------"

for size_info in "${test_sizes[@]}"; do
    read cols lines desc <<< "$size_info"
    read top left right <<< $(calculate_padding $cols $lines)
    
    printf "%-21s | %3d | %4d | %5d | " "$desc ($cols×$lines)" "$top" "$left" "$right"
    
    # Visual representation
    for i in $(seq 1 $left); do echo -n "◀"; done
    echo -n " LOGO "
    for i in $(seq 1 $right); do echo -n "▶"; done
    echo " TEXT"
done

echo ""
echo "Current Terminal: $(tput cols)×$(tput lines)"
read current_top current_left current_right <<< $(calculate_padding $(tput cols) $(tput lines))
echo "Current Padding: Top=$current_top, Left=$current_left, Right=$current_right"
echo ""
echo "✅ The logo and text padding automatically adjust for perfect balance!"
