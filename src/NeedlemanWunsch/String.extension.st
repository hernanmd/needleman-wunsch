Extension { #name : #String }

{ #category : #'*NeedlemanWunsch' }
String >> align: seq2 using: anAligner [

	^ anAligner alignFromString: self with: seq2
]
