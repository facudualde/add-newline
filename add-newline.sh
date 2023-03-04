#!/bin/bash

# A script for .c files to complete
# every printf with \n at the end
# Author: Facundo Dualde
# Twitter: @facudualde

# global variables

# variables to be used if the user wants to enter file names
_f=0
files=()

# variables to be used if the user wants to enter directory names
_d=0
directories=()
_r=0

# variables to indicate if the program must add \n to all printfs
# or only those tihat do not already have one at at the end
_a=0 
_o=0

# loops over all files given as arguments and addss \n to all printfs 
# if _a == 1. If _o == 1 then only those that do not already have one 
# at the end 
function f_mode()
{
        for f in ${files[@]}; do
                if [[ -f $f ]]; then
                        if [[ $_a == 1 ]]; then
                                sed -i 's/printf(\("[^"]*\)/printf(\1\\n/g' $f
                        elif [[ $_o == 1 ]]; then
                                sed -i '/printf/{/\\n"/!s/printf(\("[^"]*\)/printf(\1\\n/g}' $f
                        fi
                fi
        done
}

# if _r == 1, not only will it add \n to all files given as arguments,
# but also recursively to all files inside the subdirectories of each
# directory. If _r == 0, it will not be recursive.
function d_mode()
{
        for d in ${directories[@]}; do
                if [[ $_r == 0 ]]; then
                        if [[ -d $d ]]; then
                                if [[ $_a == 1 ]]; then
                                        for f in $d/*.c 
                                        do
                                                sed -i 's/printf(\("[^"]*\)/printf(\1\\n/g' $f
                                        done
                                elif [[ $_o == 1 ]]; then
                                        for f in $d/*.c 
                                        do
                                                sed -i '/printf/{/\\n"/!s/printf(\("[^"]*\)/printf(\1\\n/g}' $f
                                        done
                                fi
                        else
                                echo "No existe el directorio $d"
                                exit 1
                        fi
                else
                        if [[ -d $d ]]; then
                                if [[ $_a == 1 ]]; then
                                        for subd in `find $d -type d`
                                        do
                                                for f in $subd/*.c
                                                do
                                                     sed -i 's/printf(\("[^"]*\)/printf(\1\\n/g' $f
                                                done
                                        done
                                elif [[ $_o == 1 ]]; then
                                        for subd in `find $d -type d`
                                        do
                                                for f in $subd/*.c
                                                do
                                                sed -i '/printf/{/\\n"/!s/printf(\("[^"]*\)/printf(\1\\n/g}' $f
                                                done
                                        done
                                fi
                        fi
                fi
        done
}

# process the command line arguments, these do not need to be
# in a particular order.
while [[ $# -gt 0 ]]; do
        case "$1" in
                -f)
                        if [[ $_f == 1 ]]; then
                                echo "Error: invalid argument: -f"
                                exit 1
                        fi
                        _f=1 #true
                        shift
                        while [[ "$1" != "-a" && "$1" != "-o" && "$1" != "-f" && "$1" != "-d" && "$1" != "-r" && $# -gt 0 ]]; do
                                files+=("$1")
                                shift
                        done
                        if [ ${#files[@]} -eq 0 ]; then
                                echo "Error: incomplete argument: -f"
                                exit 1
                        fi
                        ;;
                -d)
                        if [[ $_d == 1 ]]; then
                                echo "Error: invalid argument: -d"
                                exit 1
                        fi
                        _d=1 #true
                        shift
                        while [[ "$1" != "-a" && "$1" != "-o" && "$1" != "-f" && "$1" != "-d" && "$1" != "-r" && $# -gt 0 ]]; do
                                directories+=("$1")
                                shift
                        done
                        if [ ${#directories[@]} -eq 0 ]; then
                                echo "Error: incomplete argument: -d"
                                exit 1
                        fi
                        ;;

                -a)
                        if [[ $_a == 1 ]]; then
                                echo "Error: invalid argument: -a"
                                exit 1
                        fi
                        shift
                        _a=1
                        ;;
                -o)
                        if [[ $_o == 1 ]]; then
                                echo "Error: invalid argument: -a"
                                exit 1
                        fi
                        shift
                        _o=1
                        ;;
                -r)
                        if [[ $_r == 1 ]]; then
                                echo "Error: invalid argument: -r"
                                exit 1
                        fi
                        shift
                        _r=1
                        ;;

                *)
                        echo "Error: invalid argument: $1"
                        exit 1
                        ;;
        esac
done

if [[ $_a == 0 && $_o == 0 ]]; then
        echo "Error: argument missing: add -a or -o"
        exit 1
elif [[ $_a == 1 && $_o == 1 ]]; then
        echo "Error: double argument: -a -o"
        exit 1
fi

if [[ $_f == 1 ]]; then
        f_mode
fi

if [[ $_r == 1 && $_d == 0 ]]; then
        echo "Error: invalid argument: -r"
        exit 1
elif [[ $_d == 1 ]]; then
        d_mode
fi