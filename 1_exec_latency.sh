Operation="Runa Runb Runc Rund Runf"

Memory="DRAM PMEM TDM"


for op in $Operation;do

    OFILE=YCSB_latency_"$op".rslt
    echo "Redis DRAM PMEM TDM" > $OFILE
   
    if [[ $op == "Loada" ]]; then
        workloads="READ UPDATE"
    elif [[ $op == "Runa" ]]; then
        workloads="READ UPDATE"
    elif [[ $op == "Runb" ]]; then
        workloads="READ UPDATE"
    elif [[ $op == "Runc" ]]; then
        workloads="READ"
    elif [[ $op == "Rund" ]]; then
        workloads="READ INSERT"
    elif [[ $op == "Rune" ]]; then
        workloads="INSERT SCAN"
    elif [[ $op == "Runf" ]]; then
        workloads="READ READ-MODIFY-WRITE UPDATE"
    
    fi

    for wo in $workloads; do
        echo "$wo" | tr "\n" " "  >> "$OFILE"
        for M in $Memory;do
            n=0
            rm test.txt
            while [[ $n -lt 1 ]];do
                File="$M"_"$op"_$n.txt
                cat $File | grep $wo | grep "AverageLatency" | awk '{print $3}'>> test.txt
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
done
