Extension { #name : #Array }

{ #category : #'*NeedlemanWunsch' }
Array >> align: seq2 using: anAligner [

	^ anAligner alignFromArray: self with: seq2
]
