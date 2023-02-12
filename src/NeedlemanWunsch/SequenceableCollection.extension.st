Extension { #name : #SequenceableCollection }

{ #category : #'*NeedlemanWunsch' }
SequenceableCollection >> align: seq2 using: anAligner [

	^ anAligner alignFromSequenceableCollection: self with: seq2
]
