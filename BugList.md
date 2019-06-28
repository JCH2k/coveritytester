# insufficient array initalization
* #001
* InitializationOfArrays.cpp
Ein Array mit n Elementen wird aber nur bei n-1 Elementen mit 0 Initalisiert.

# over-inizialisization of array
* #002
* InitializationOfArrays.cpp
Ein Array mit n Elementen wir an n+1 Elementen beschrieben.

# compiler warning
* #003
* TestWarning.cpp
Ein Test vom compiler warning.

# wrong dereferencing
* #004
* DummyClass.cpp
In einer Funktion wird ein Object per Pointer übergebenen. Hier besteht bei einer Zuweisung die Gefahr dass man den (lokalen) Pointer ändert, statt das übergebene Object.

# over-inizialization of array by sizeof operator
* #005
* InitializationOfArrays.cpp
Ähnlich wie #002, außer dass die Arraygröße anhand des sizeof-Operators bestimmt wird.

# assignement in if condition
* #006
* main.cpp
Zuweisung in einer if-Bedingung ist meistens nicht beabsichtigt.

# mismatch of allocation/deallocation
* #007
* main.cpp
Ein new[] muss auch mit einem delete[] gelöscht werden.

# uninit variable
* #008
* misc.cpp
Bool Variable wird uninitialisiert verwendet.

# dead code
* #009
* misc.cpp
Codestelle kann nicht erreicht werden.

# missing break
* #010
* misc.cpp
Ein fehlendes break in einer switch-Anweisung für zu ungewolltem Verhalten.

# unread variable
* #011
* misc.cpp
Eine Variable mehrfach zu schreiben bevor sie gelesen wird ist unnötig.

# dangling pointer
* #012
* misc.cpp
Pointer zeigt auf Speicher der nicht mehr zugewiesen ist.
