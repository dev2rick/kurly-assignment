function hasSubModules() {
    for sub in $subModules
    do
        if [[ $sub == 'Tests/' ]]; then 
            hasSubModules=false
        fi
    done
}

function xcodeTest() {
    if command -v xcpretty &> /dev/null; then
        xcodebuild test -scheme "$scheme" -destination "$DESTINATION" | xcpretty -s
    else
        xcodebuild test -scheme "$scheme" -destination "$DESTINATION" -quiet
    fi

    if [[ $? == 0 ]]; then
        successList+="$scheme"$' Success\n'
    else
        failList+="$scheme"$' Failed\n'
    fi
}

DESTINATION=$1

modules="*/"
for module in $modules
do
    moduleName=${module#"Module/"}
    cd ./$module

    subModules='*/'
    hasSubModules=true
    hasSubModules

    if [[ $hasSubModules == true ]]; then
        scheme=${moduleName%?}"-Package"
    else
        scheme=${moduleName%?} # ex: 'dic'
    fi

    echo $'------------------ '$scheme' Start ------------------'
    xcodeTest

    cd ..
    echo $'------------------ '$scheme' End --------------------'
    
done
echo $'------------------ success ----------------------'
echo "$successList"
echo $'------------------- fail ------------------------'
echo "$failList"
echo $'-------------------------------------------------'
