:!echo > uml.pu
:r !ag -l startuml
:<c-u>normal ggVGJ
:g/^$/ d
:argadd 
:argdo g/@startuml/ .,/@enduml/ norm gcc
:argdo g/@startuml/ .,/@enduml/ s/^ \+//g
:argdo g/@startuml/ .,/@enduml/ !cat >> uml.pu
:!java -jar $HOME/lib/java/plantuml.jar -tsvg uml.pu
:qa!
