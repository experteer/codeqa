Codeqa.configure do |config|
  config.excludes = ['vendor/**/*']
  config.enabled_checker = %w(CheckErb
                              CheckErbHtml
                              CheckRubySyntax
                              CheckStrangeChars
                              CheckUtf8Encoding
                              CheckConflict
                              CheckPry
                              CheckLinkto
                              CheckRspecFocus)
  config.erb_engine = 'erb'
  config.rubocop_formatter_cops = %w( EmptyLinesAroundBody
                                      EmptyLines
                                      TrailingWhitespace
                                      SpaceBeforeBlockBraces
                                      SpaceInsideBlockBraces
                                      SpaceAroundEqualsInParameterDefault
                                      SpaceAfterComma
                                      SingleSpaceBeforeFirstArg
                                      SpaceInsideHashLiteralBraces
                                      SpaceAroundOperators
                                      SpaceInsideParens
                                      LeadingCommentSpace
                                      EmptyLineBetweenDefs
                                      IndentationConsistency
                                      IndentationWidth
                                      MethodDefParentheses
                                      DefWithParentheses
                                      HashSyntax
                                      AlignArray
                                      AlignParameters
                                      BracesAroundHashParameters )
  # other interessting but currently not enabled default cops
  # AlignHash
  # SignalException
  # DeprecatedClassMethods
  # RedundantBegin
  # RedundantSelf
  # RedundantReturn
  # CollectionMethods
end
