#!/bin/bash

OLDIFS=$IFS
IFS=,

#This script makes the Thermocalc Macro file from inputs taken from a CSV file.
#Make sure that the CSV file has an extra row and an extra column in the end with absolutely anything in it,
#it will be ignored

INPUT=real_data.csv

{
	read T el[1] el[2] el[3] el[4] el[5] el[6] el[7] el[8] el[9] el[10] el[11] el[12] el[13] extra #reads elements from first line, which is the header. Note that the last column is ignored, and should just have something
	while read -r T X[1] X[2] X[3] X[4] X[5] X[6] X[7] X[8] X[9] X[10] X[11] X[12] X[13] extra2
		do
		{
			num=1
			totalnum=${#el[@]}
		
			echo "go da"
			echo "sw ttni8"
			# echo "def-sp" Ni ${el[1]} ${el[2]} ${el[3]}
			echo "def-sp" Ni 
			while ((num<=totalnum))
			do
				echo "def-sp" ${el[num]}
				((num++))
			done
			num=1
			echo "rej p"
			echo "*"
			echo "rest p"
			echo "FCC_A1"
			echo "get_data"
			echo "goto poly"
			echo "s-c n=1 p=1e5 t="$T
			# echo "s-c X("${el[1]}")="${X[1]}
# 			echo "s-c X("${el[2]}")="${X[2]} 
# 			echo "s-c X("${el[3]}")="${X[3]} 
			while ((num<=totalnum))
			do
				echo "s-c X("${el[num]}")="${X[num]}
				((num++))
			done
			num=1
			echo "c-e"
			echo ""
			
			while ((num < totalnum))
			do
				num2=$((num+1))
				while ((num2<=totalnum))
				do
					echo "s-a-v 1 X("${el[(($num))]}")" $(bc<<<"scale=10; ${X[$num]}-${X[$num]}*0.01") $(bc<<<"scale=10; ${X[$num]}+${X[$num]}*0.01") $(bc<<<"scale=10; ${X[$num]}*0.01")
					echo "step"
					echo ""
					echo "enter_sym"
					echo "fun"
					echo "DG"${el[$num]}${el[$num2]}
					echo "GM(FCC_A1).X("${el[$num2]}")"
					echo ""
					echo "enter_sym"
					echo "tab"
					echo "tab"${el[$num]}${el[$num2]}
					echo "X("${el[$num]}") DG"${el[$num]}${el[$num2]}
					echo ""
					echo "tabulate tab"${el[$num]}${el[$num2]}
					echo "file "${el[$num]}"_"${el[$num2]}"_data.txt"
					echo ""
					echo "del_sym"
					echo "tab"${el[$num]}${el[$num2]}
					echo "del_sym"
					echo "DG"${el[$num]}${el[$num2]}
					((num2++))
				done
				((num++))
			done
		}>$T"_with_D.tcm"
		done
}	< $INPUT
IFS=$OLDIFS