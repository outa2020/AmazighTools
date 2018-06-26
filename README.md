# AmazighTools
Amazigh Tools

1. Amazigh POS tagger(including a tokenizer): The POS tagger(using CRFs) with the tokenizer(using SVMs) are used both in this package. -This is the current POS tagger program(the tool accuracy is 93.82%). Usage: AmPOSrun.pl filename.
2. A CRF model trained for Amazigh POS tagging(28 tags). The input file should be in chosen writen system, and the text to tokenized.
3. The tokenizer: an SVM model trained for Amazigh tokenization.
4. baseline script: it is computed by calculating the most frequent PoS tag associated with a token from the training data which is assigned to it in the test set, regardless of context.
5. Segmentation tool : bondary tool.
