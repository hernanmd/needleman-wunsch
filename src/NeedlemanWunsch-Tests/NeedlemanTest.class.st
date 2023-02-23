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
NeedlemanTest >> testAlignWithCollectionsOfStrings [

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
NeedlemanTest >> testAlignWithDNASequenceLong [

	| expected expectedAlign1 expectedAlign2 inputSeq1 inputSeq2 |

	expectedAlign1 := 'ATGGTGCTGTCTCCT---GCCGACAAGACCAACGTCAAGGCCGCCTGGGGTAAGGTCGG-CGCG
CACGCTGGC-GAGTATGGTGCGGAGGCCCTGGAGAGGATGTTCCTG-T-CCTTCCCCACCACC
AAGACCTACTTCCCGCACTTCGACCTG--AGCCACGGCTCTGCCCAAGTTAAGGGCCACGGC
AAGAAGGTGGCCGACGCGCTGACCAACGCCG-TGGCGCACGTGGACGACATGCCCAACGCG
CTGTCCGCCCTGAGCGACCTGCACGCGCACAAGCTTCGGGTGGA-CCCGGTCAACTTCAAG
CTCCTAAGCCACTGCCTGCTGGTGACCCTGGC-CGCCCACCTCCCCGCCGAGTTCACCCCT
GCGGTGCACGCTTCCCTGGACAAGTTCCTGGCTTCTGTGAGCACCGTGCTGACCTCCAAA
TACCGTTAA'.
	expectedAlign2 := 'ATGGTGC--TCT-CTGGGGAAGACAAAAGCAACATCAAGGCTGCCTGGGGGAAGATTGGTGGC-
CATGGT-GCTGAATATGGAGCTGAAGCCCTGGAAAGGATGTT--TGCTAGCTTCCCCACCACC
AAGACCTACTTTCCTCACTTTGA--TGTAAGCCACGGCTCTGCCCAGGTCAAGGGTCACGGC
AAGAAGGTCGCCGATGCGCTGGCCAGTGCTGCAGGC-CACCTCGATGACCTGCCCGGTGCC
TTGTCTGCTCTGAGCGACCTGCATGCCCACAAGCTGCGTGTGGATCCC-GTCAACTTCAAG
CTCCTGAGCCACTGCCTGCTGGTGACCTTGGCTAG-CCACCACCCTGCCGATTTCACCCCC
GCGGTACATGCCTCTCTGGACAAATTCCTTGCCTCTGTGAGCACCGTGCTGACCTCCAAG
TACCGTTAA'.
	expected := expectedAlign1 -> expectedAlign2.

	inputSeq1 := 'ATGGTGCTGTCTCCTGCCGACAAGACCAACGTCAAGGCCGCCTGGGGTAAGGTCGGCGCG
CACGCTGGCGAGTATGGTGCGGAGGCCCTGGAGAGGATGTTCCTGTCCTTCCCCACCACC
AAGACCTACTTCCCGCACTTCGACCTGAGCCACGGCTCTGCCCAAGTTAAGGGCCACGGC
AAGAAGGTGGCCGACGCGCTGACCAACGCCGTGGCGCACGTGGACGACATGCCCAACGCG
CTGTCCGCCCTGAGCGACCTGCACGCGCACAAGCTTCGGGTGGACCCGGTCAACTTCAAG
CTCCTAAGCCACTGCCTGCTGGTGACCCTGGCCGCCCACCTCCCCGCCGAGTTCACCCCT
GCGGTGCACGCTTCCCTGGACAAGTTCCTGGCTTCTGTGAGCACCGTGCTGACCTCCAAA
TACCGTTAA'.
	inputSeq2 := 'ATGGTGCTCTCTGGGGAAGACAAAAGCAACATCAAGGCTGCCTGGGGGAAGATTGGTGGC
CATGGTGCTGAATATGGAGCTGAAGCCCTGGAAAGGATGTTTGCTAGCTTCCCCACCACC
AAGACCTACTTTCCTCACTTTGATGTAAGCCACGGCTCTGCCCAGGTCAAGGGTCACGGC
AAGAAGGTCGCCGATGCGCTGGCCAGTGCTGCAGGCCACCTCGATGACCTGCCCGGTGCC
TTGTCTGCTCTGAGCGACCTGCATGCCCACAAGCTGCGTGTGGATCCCGTCAACTTCAAG
CTCCTGAGCCACTGCCTGCTGGTGACCTTGGCTAGCCACCACCCTGCCGATTTCACCCCC
GCGGTACATGCCTCTCTGGACAAATTCCTTGCCTCTGTGAGCACCGTGCTGACCTCCAAG
TACCGTTAA'.

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

{ #category : #tests }
NeedlemanTest >> testAlignWithWordSequence1 [

	| expected expectedAlign1 expectedAlign2 inputSeq1 inputSeq2 |

	expectedAlign1 := 'IMPRESIONABLE'.
	expectedAlign2 := 'IMPRES-O-----'.
	expected := expectedAlign1 -> expectedAlign2.

	inputSeq1 := 'IMPRESIONABLE'.
	inputSeq2 := 'IMPRESO'.

	aligner align: inputSeq1 with: inputSeq2.

	self
		assertCollection: aligner firstSequence
		hasSameElements: expected key.

	self
		assertCollection: aligner secondSequence
		hasSameElements: expected value
]

{ #category : #tests }
NeedlemanTest >> testAlignWithWordSequence1Reverse [

	| expected expectedAlign1 expectedAlign2 inputSeq1 inputSeq2 |

	expectedAlign1 := 'IMPRES-O-----'.
	expectedAlign2 := 'IMPRESIONABLE'.
	expected := expectedAlign1 -> expectedAlign2.

	inputSeq1 := 'IMPRESO'.
	inputSeq2 := 'IMPRESIONABLE'.

	aligner align: inputSeq1 with: inputSeq2.

	self
		assertCollection: aligner firstSequence
		hasSameElements: expected key.

	self
		assertCollection: aligner secondSequence
		hasSameElements: expected value
]

{ #category : #tests }
NeedlemanTest >> testAlignWithWordSequence2 [

	| expected expectedAlign1 expectedAlign2 inputSeq1 inputSeq2 |

	expectedAlign1 := 'IMPRES-IONABLE'.
	expectedAlign2 := 'INCUESTIONABLE'.
	expected := expectedAlign1 -> expectedAlign2.

	inputSeq1 := 'IMPRESIONABLE'.
	inputSeq2 := 'INCUESTIONABLE'.

	aligner align: inputSeq1 with: inputSeq2.

	self
		assertCollection: aligner firstSequence
		hasSameElements: expected key.

	self
		assertCollection: aligner secondSequence
		hasSameElements: expected value
]

{ #category : #tests }
NeedlemanTest >> testAlignWithWordSequence2Reverse [

	| expected expectedAlign1 expectedAlign2 inputSeq1 inputSeq2 |

	expectedAlign1 := 'INCUESTIONABLE'.
	expectedAlign2 := 'IMPRES-IONABLE'.
	expected := expectedAlign1 -> expectedAlign2.

	inputSeq1 := 'INCUESTIONABLE'.
	inputSeq2 := 'IMPRESIONABLE'.

	aligner align: inputSeq1 with: inputSeq2.

	self
		assertCollection: aligner firstSequence
		hasSameElements: expected key.

	self
		assertCollection: aligner secondSequence
		hasSameElements: expected value
]

{ #category : #tests }
NeedlemanTest >> testAlignWithWordSequence3 [

	| expected expectedAlign1 expectedAlign2 inputSeq1 inputSeq2 |

	expectedAlign1 := 'SIMILARITY'.
	expectedAlign2 := 'PI-LLAR---'.
	expected := expectedAlign1 -> expectedAlign2.

	inputSeq1 := 'SIMILARITY'.
	inputSeq2 := 'PILLAR'.

	aligner align: inputSeq1 with: inputSeq2.

	self
		assertCollection: aligner firstSequence
		hasSameElements: expected key.

	self
		assertCollection: aligner secondSequence
		hasSameElements: expected value
]
