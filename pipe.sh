#!/usr/bin/env sh
init () {
    if test -e $1; then
        echo "$1 already exists"
        exit 1
    fi
    file=$1
    shift
    echo "#!/usr/bin/env sh\nCOMMAND=\"$@\"\n" >> $file
    sed "/^#code$/,/^#endcode/!d" $0 >> $file
    chmod +x $file
}

#code
run () {
    dir="$(mktmpdir)"
    extract "$dir"
    sh -c "cd $dir && $1" || exit $?
}

execute () {
    if ! test -z $REQUIRES; then
        $REQUIRES extract "$1" || exit $?
    fi

    sh -c "cd $1 && $COMMAND" || exit $?

    clear

    echo "\n#artifact" >> $0
    tar c -C "$1" . | base64 >> $0
}

mktmpdir () {
    if test -z $dir; then
        dir="$(mktemp -d)"
    fi
    echo "$dir"
}

clear () {
    if grep -q "^#artifact$" $0; then
        sed -i "/^#artifact$/,\$d" $0
        sed -i "\$d" $0
    fi
}

extract () {
    if ! grep -q "^#artifact$" $0; then
        execute "$1"
    fi
    artifact | base64 -d | tar x -C "$1"
}

artifact () {
    sed "1,/^#artifact$/d" $0
}

print () {
    echo "#!/usr/bin/env sh\n\nREQUIRES=\"$(readlink -f "$0")\"\nCOMMAND=\"$@\"\n"
    sed "/^#code$/,/^#endcode/!d" $0
}

to () {
    if test -e $1; then
        echo "$1 already exists"
        exit 1
    fi
    print "$2" > $1
    chmod +x $1
}

trap 'rm -rf -- "$dir"' EXIT

if test -z $1
then
    execute "$(mktmpdir)"
else
    f=$1
    shift
    $f "$@"
fi

exit
#endcode
