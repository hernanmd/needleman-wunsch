"
Implements a Pairwise Sequence Aligner which expect to read two input sequences (`firstSequence:` and `secondSequence:`) and calculate their optimal global (end to end) sequence alignment using the algorithm developed by Saul B. Needleman and Christian D. Wunsch and published in 1970, known as Needleman-Wunsch.

It is used to identify regions of similarity between two sequences. When applied to two biological sequences (protein or nucleic acid), it may indicate functional, structural and/or evolutionary relationships between them. It is most useful when the sequences in the query set are similar and of roughly equal size. (This does not mean global alignments cannot start and/or end in gaps.)

## Usage

```language=Pharo
""Obtain the resulting alignment as Association""
(ALNeedlemanWunsch align: 'IMPRESIONABLE' with: 'IMPRESO') asAssociation.

""You can use it directly applying to Strings, and get the result as a Collection""
('IMPRESIONABLE' alignUsingNWWith: 'IMPRESO') asArray.

""More verbose usage using `firstSequence:` and `secondSequence:` to set the two sequences to be compared. They can be two `String` or two `Collection`s containing `String`s.""
ALNeedlemanWunsch new
	firstSequence: 'IMPRESIONABLE';
	secondSequence: 'IMPRESO';
	align.
```

## Scoring

Given scores for perfect matches, mismatches, and gap penalties, the algorithm will produce an optimal alignment.

- The algorithm uses a ""scoring system"": it consists of ""residue"" substitution scores (i.e. score for each possible residue alignment), plus penalties for gaps.
- The alignment score is the sum of substitution scores and gap penalties.
- It is possible to change the scoring system sending the messages `matchAward:` , `mismatchPenalty:` and `gapPenalty:`.
- More complicated scoring systems could be used through Evolutionary substitution matrices (see BioSmalltalk for BLOSUM and PAM matrices).

# Implementation Points

Implementation is based on dynamic programming and performs a general ""Global alignment"", it assigns a score to every possible alignment, and find all possible alignments having the highest score. 
"
Class {
	#name : #ALNeedlemanWunsch,
	#superclass : #Object,
	#instVars : [
		'matchAward',
		'mismatchPenalty',
		'gapPenalty',
		'firstSequence',
		'secondSequence',
		'gapCharacter'
	],
	#category : #NeedlemanWunsch
}

{ #category : #transforming }
ALNeedlemanWunsch class >> align: seq1 with: seq2 [
	" Answer a new instance of the receiver with the input sequences aligned "

	^ self new
		align: seq1 with: seq2;
		yourself
]

{ #category : #initialization }
ALNeedlemanWunsch >> align [
	"Align the receiver's configured sequences. Answer the receiver"

	self
		align: self firstSequence
		with: self secondSequence
]

{ #category : #initialization }
ALNeedlemanWunsch >> align: seq1 with: seq2 [

	^ seq1 alignUsingNW: seq2 for: self
]

{ #category : #initialization }
ALNeedlemanWunsch >> alignFromSequenceableCollection: seq1 with: seq2 [

	| lengthSeq1 lengthSeq2 score match delete insert align1 align2 ti tj scoreCurrent scoreDiagonal scoreUp scoreLeft |

	(seq1 isEmpty and: [ seq2 isEmpty ]) ifTrue: [ ^ self ].

	lengthSeq1 := seq1 size.
	lengthSeq2 := seq2 size.

	"Matrix initialisation"
	score := self zeros: (lengthSeq1 + 1) -> (lengthSeq2 + 1).
	"Fill first row with gap penalties"
	0 to: lengthSeq1 do: [ : i |
		score at: i + 1 at: 1 put: self gapPenalty * i ].
	"Fill first column with gap penalties"
	0 to: lengthSeq2 do: [ : j |
		score at: 1 at: j + 1 put: self gapPenalty * j ].

	1 to: lengthSeq1 do: [ : i |
		1 to: lengthSeq2 do: [ : j |
			match := (score at: i at: j) + (self matchScore: (seq1 at: i) with: (seq2 at: j)).
			delete := (score at: i at: j + 1) + self gapPenalty.
			insert := (score at: i + 1  at: j) + self gapPenalty.
			score at: i + 1 at: j + 1 put: ({ match . delete . insert } max) ] ].

	align1 := OrderedCollection new.
	align2 := OrderedCollection new.
	ti := lengthSeq1 + 1.
	tj := lengthSeq2 + 1.

	" Follow the traceback score matrix "
	[ ti > 1 and: [ tj > 1 ]] whileTrue: [
		scoreCurrent := score at: ti at: tj.
		scoreDiagonal := score at: ti - 1 at: tj - 1.
		scoreUp := score at: ti at: tj - 1.
		scoreLeft := score at: ti - 1 at: tj.

		scoreCurrent = (scoreDiagonal + (self matchScore: (seq1 at: ti - 1) with: (seq2 at: tj - 1)))
			ifTrue: [
				align1 add: (seq1 at: ti - 1).
				align2 add: (seq2 at: tj - 1).
				ti := ti - 1.
				tj := tj - 1 ]
			ifFalse: [
				scoreCurrent = (scoreLeft + self gapPenalty)
					ifTrue: [
						align1 add: (seq1 at: ti - 1).
						align2 add: gapCharacter.
						ti := ti - 1 ]
					ifFalse: [
						scoreCurrent = (scoreUp + self gapPenalty)
							ifTrue: [
								align1 add: gapCharacter.
								align2 add: (seq2 at: tj -1).
								tj := tj - 1 ] ]  ] ].

	[ ti > 1 ] whileTrue: [
		align1 add: (seq1 at: ti - 1).
		align2 add: gapCharacter.
		ti := ti - 1 ].
	[ tj > 1 ] whileTrue: [
		align1 add: gapCharacter.
		align2 add: (seq2 at: tj - 1).
		tj := tj - 1 ].

	self finalize: align1 with: align2
]

{ #category : #accessing }
ALNeedlemanWunsch >> alignFromString: seq1 with: seq2 [

	self alignFromSequenceableCollection: seq1 with: seq2 .
	self firstSequence: (self firstSequence joinUsing: '').
	self secondSequence: (self secondSequence joinUsing: '')
]

{ #category : #converting }
ALNeedlemanWunsch >> asArray [
	"Answer the receiver's first and second sequence as <Array>"
	
	^ Array
		with: self firstSequence
		with: self secondSequence
]

{ #category : #converting }
ALNeedlemanWunsch >> asAssociation [
	"Answer the receiver's first and second sequence as <Association>"
	
	^ self firstSequence -> self secondSequence
]

{ #category : #initialization }
ALNeedlemanWunsch >> finalize: align1 with: align2 [

	| j found score identity |

	firstSequence := align1 reversed.
	secondSequence := align2 reversed.
	j := 0.
	found := 0.
	score := 0.
	identity := 0.
	1 to: firstSequence size do: [ : i |
		| localA1i localA2i |
		localA1i := firstSequence at: i.
		localA2i := secondSequence at: i.
		localA1i = localA2i
			ifTrue: [
				identity := identity + 1.
				score := score + (self matchScore: localA1i with: localA2i) ]
			ifFalse: [
				 (localA1i ~= localA2i and: [ localA1i ~= gapCharacter and: [ localA2i ~= gapCharacter ] ])
					ifTrue: [
						score := score + (self matchScore: localA1i with: localA2i).
						found := 0 ]
					ifFalse: [
						(localA1i = gapCharacter or: [ localA2i = gapCharacter ])
							ifTrue: [ score := score + self gapPenalty ] ] ] ].
	identity := identity asFloat / firstSequence size
]

{ #category : #accessing }
ALNeedlemanWunsch >> firstSequence [
	"Answer a <Collection> with the first aligned sequence"

	^ firstSequence
		ifNil: [ firstSequence := Array new ]
]

{ #category : #accessing }
ALNeedlemanWunsch >> firstSequence: anObject [

	firstSequence := anObject
]

{ #category : #accessing }
ALNeedlemanWunsch >> gapCharacter [

	^ gapCharacter
]

{ #category : #accessing }
ALNeedlemanWunsch >> gapCharacter: anObject [

	gapCharacter := anObject
]

{ #category : #accessing }
ALNeedlemanWunsch >> gapPenalty [

	^ gapPenalty
]

{ #category : #accessing }
ALNeedlemanWunsch >> gapPenalty: anObject [

	gapPenalty := anObject
]

{ #category : #initialization }
ALNeedlemanWunsch >> initialize [

	super initialize.
	matchAward := 20.
	mismatchPenalty := -5.
	gapPenalty := -5.
	gapCharacter := '-'
]

{ #category : #accessing }
ALNeedlemanWunsch >> matchAward [

	^ matchAward
]

{ #category : #accessing }
ALNeedlemanWunsch >> matchAward: anObject [

	matchAward := anObject
]

{ #category : #initialization }
ALNeedlemanWunsch >> matchScore: alpha with: beta [

	alpha = beta
		ifTrue: [ ^ self matchAward ]
		ifFalse: [
			^ (alpha = gapCharacter or: [ beta = gapCharacter ])
				ifTrue: [ self gapPenalty ]
				ifFalse: [ self mismatchPenalty ] ]
]

{ #category : #accessing }
ALNeedlemanWunsch >> mismatchPenalty [

	^ mismatchPenalty
]

{ #category : #accessing }
ALNeedlemanWunsch >> mismatchPenalty: anObject [

	mismatchPenalty := anObject
]

{ #category : #accessing }
ALNeedlemanWunsch >> secondSequence [
	"Answer a <Collection> with the second aligned sequence"

	^ secondSequence
		ifNil: [ secondSequence := Array new ]
]

{ #category : #accessing }
ALNeedlemanWunsch >> secondSequence: anObject [

	secondSequence := anObject
]

{ #category : #'special instance creation' }
ALNeedlemanWunsch >> zeros: shapeAssoc [
	"Answer a new DP matrix "

	^ PMMatrix
		zerosRows: shapeAssoc key
		cols: shapeAssoc value
]
