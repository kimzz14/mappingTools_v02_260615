#!/bin/sh

#PBS -N map-At-A00000
#PBS -q nabic
#PBS -l select=30:ncpus=24
#PBS -e ./pbs.log
#PBS -o ./pbs.err

cd $PBS_O_WORKDIR
module use /s3/opt/modulefiles/

aprun -n 30 -N 1 -d 24 bash batch/aprun.sh run0001
