Extension { #name : 'SequenceableCollection' }

{ #category : '*NeedlemanWunsch' }
SequenceableCollection >> alignUsingNW: seq2 for: anAligner [

	^ anAligner alignFromSequenceableCollection: self with: seq2
]
