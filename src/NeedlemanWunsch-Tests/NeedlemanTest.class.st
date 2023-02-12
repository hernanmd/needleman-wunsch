"
A NeedlemanTest is a test class for testing the behavior of Needleman
"
Class {
	#name : #NeedlemanTest,
	#superclass : #TestCase,
	#instVars : [
		'aligner'
	],
	#category : #'NeedlemanWunsch-Tests'
}

{ #category : #running }
NeedlemanTest >> setUp [

	super setUp.
	aligner := ALNeedlemanWunsch new
]

{ #category : #tests }
NeedlemanTest >> testAlignWith [

	| expected expectedAlign1 expectedAlign2 inputSeq1 inputSeq2 |
	expectedAlign1 := { 'a' . 'b' . 'c' . 'd' . 'e' . 'f' . '-' . '-' . '-' }.
	expectedAlign2 := { '-' . '-' . 'c' . 'd' . '-' . 'f' . 'j' . 'k' . 'l' }.
	expected := expectedAlign1 -> expectedAlign2.

	inputSeq1 := #('a' 'b' 'c' 'd' 'e' 'f').
	inputSeq2 := #('c' 'd' 'f' 'j' 'k' 'l').

	aligner align: inputSeq1 with: inputSeq2.

	self
		assertCollection: aligner firstSequence
		hasSameElements: expected key.

	self
		assertCollection: aligner secondSequence
		hasSameElements: expected value
]

{ #category : #tests }
NeedlemanTest >> testAlignWithDNASequence [

	| expected expectedAlign1 expectedAlign2 inputSeq1 inputSeq2 |

	expectedAlign1 := 'AC-AATAGAC'.
	expectedAlign2 := 'ACGAATAGAT'.
	expected := expectedAlign1 -> expectedAlign2.

	inputSeq1 := 'ACAATAGAC'.
	inputSeq2 := 'ACGAATAGAT'.

	aligner align: inputSeq1 with: inputSeq2.

	self
		assertCollection: aligner firstSequence
		hasSameElements: expected key.

	self
		assertCollection: aligner secondSequence
		hasSameElements: expected value
]

{ #category : #tests }
NeedlemanTest >> testAlignWithEmptySequences [

	| expected inputSeq1 inputSeq2 |

	expected := { } -> { }.

	inputSeq1 := #().
	inputSeq2 := #().

	aligner align: inputSeq1 with: inputSeq2.

	self
		assertCollection: aligner firstSequence
		hasSameElements: expected key.

	self
		assertCollection: aligner secondSequence
		hasSameElements: expected value
]
