Get-ChildItem ./flutter_build/ -Recurse |? LinkType -eq 'SymbolicLink' |% { $_.Delete() }
rm -Recurse -ErrorAction Ignore ./flutter_build/;
mkdir ~/flutter_build;
