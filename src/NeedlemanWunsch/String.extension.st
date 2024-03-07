Extension { #name : 'String' }

{ #category : '*NeedlemanWunsch' }
String >> alignUsingNW: seq2 for: anAligner [

	^ anAligner alignFromString: self with: seq2
]

{ #category : '*NeedlemanWunsch' }
String >> alignUsingNWWith: aString [
	"Answer a new instance of <ALNeedlemanWunsch>, the Needleman-Wunsch aligner calculated for the receiver and aString"

	^ ALNeedlemanWunsch new alignFromString: self with: aString
]
