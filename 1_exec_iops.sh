Operation="Loada Runa Runb Runc Rund Rune Runf"

Memory="DRAM PMEM TDM"

OFILE=YCSB.rslt
echo "Redis DRAM PMEM TDM" > $OFILE

for op in $Operation;do
    if [[ $op == "Loada" ]]; then
        echo "Load" | tr "\n" " " >> $OFILE
    elif [[ $op == "Runa" ]]; then
        echo "Run_A" | tr "\n" " " >> $OFILE
    elif [[ $op == "Runb" ]]; then
        echo "Run_B" | tr "\n" " " >> $OFILE
    elif [[ $op == "Runc" ]]; then
        echo "Run_C" | tr "\n" " " >> $OFILE
    elif [[ $op == "Rund" ]]; then
        echo "Run_D" | tr "\n" " " >> $OFILE
    elif [[ $op == "Rune" ]]; then
        echo "Run_E" | tr "\n" " " >> $OFILE
    elif [[ $op == "Runf" ]]; then
        echo "Run_F" | tr "\n" " " >> $OFILE
    fi
    for M in $Memory;do
        n=0
        rm test.txt
        while [[ $n -lt 1 ]];do
            File="$M"_"$op"_$n.txt
            cat $File | grep "Throughput" | awk '{print $3}'>> test.txt
            n=$(( $n + 1 ))
        done
        cat test.txt | sort -nr 

        
        if [ $M != "TDM" ]; then
            cat test.txt | sort -nr | head -n 1 | tail -n 1 | awk '{n+=$1} END {printf("%f ",n)}' >> "$OFILE"
#cat $File | grep $op | awk '{print $2}' | tr "\n" " ">> "$OFILE"
        else
            cat test.txt | sort -nr | head -n 1 | tail -n 1 | awk '{n+=$1} END {printf("%f\n",n)}' >> "$OFILE"
#				cat $File | grep $op | awk '{print $2}'>> "$OFILE"
        fi
    done
done
