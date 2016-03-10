#!/bin/bash

OLDIFS=$IFS
IFS=,

#This script makes the Thermocalc Macro file from inputs taken from a CSV file.
#Make sure that the CSV file has an extra line in the end with absolutely anything in it,
#it will be ignored

INPUT=book3.csv

{
	read T el[1] el[2] el[3] extra #reads elements from first line, which is the header. Note that the last column is ignored, and should just have something
	while read -r T X[1] X[2] X[3] extra2
		do
		{
		num=1
		totalnum=${#el[@]}
		
		echo "go da"
		echo "sw fe"
		echo "def-sp" Ni ${el[1]} ${el[2]} ${el[3]} 
		echo "rej p
*
rest p
FCC_A1
get_data
goto poly"
		echo "s-c n=1 p=1e5 t="$T
		echo "s-c X("${el[1]}")="${X[1]}
		echo "s-c X("${el[2]}")="${X[2]} 
		echo "s-c X("${el[3]}")="${X[3]} 
		echo "c-e"
		echo ""
		while ((num < totalnum))
			do
			#change=$(bc<<<"scale=10; ${X[$num]}*0.1")
			echo "s-a-v 1 X("${el[(($num))]}")" $(bc<<<"scale=10; ${X[$num]}-${X[$num]}*0.001") $(bc<<<"scale=10; ${X[$num]}+${X[$num]}*0.001") $(bc<<<"scale=10; ${X[$num]}*0.001")
			echo "step"
			echo ""
			echo "enter_sym"
			echo "fun"
			echo "DG_"${el[(($num))]}"_"${el[(($num+1))]}
			echo "GM(FCC_A1).X("${el[(($num+1))]}")"
			echo ""
			echo "enter_sym"
			echo "tab"
			echo "dg_table_"${el[(($num))]}"_"${el[(($num+1))]}
			echo "X("${el[$num]}") DG_"${el[(($num))]}"_"${el[(($num+1))]}
			echo ""
			#echo "post"
			#echo "s-d-a y gm(FCC_A1)"
			#echo "s-d-a x X("${el[$num]}")"
			#echo "list_data_table "$T"_"${el[$num]}
			#echo "set_interactive"
			echo "tabulate dg_table_"${el[(($num))]}"_"${el[(($num+1))]}
			echo "file "${el[$num]}"_"${el[$num+1]}"_data.txt"
			echo ""
			((num++))
		done
		}>$T"_with_D.tcm" 
	done
}	< $INPUT 
IFS=$OLDIFS