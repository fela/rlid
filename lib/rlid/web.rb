module Rlid

class LanguageProbabilities
  CLASSNAME = "languageresult"

  def to_html
    sorted[0...MAX_OUTPUT].map do |x|
      perc = Percentage.new(x[PERC]).to_s
      lang = Language.name_of(x[LANG])
      "<div class='#{CLASSNAME}'>" +
        "#{lang} (#{perc}% chance)</div>"
    end.join("\n")
  end
end

end # module Rlid
