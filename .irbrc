IRB.conf[:PROMPT_MODE] = :DEFAULT
IRB.conf[:IRB_NAME] = 'aggregator'
IRB.conf[:PROMPT][:AGGREGATOR] = {
	:PROMPT_C => '%N(%03n)-> ',
	:PROMPT_I => '%N(%03n)-> ',
	:PROMPT_N => '%N(%03n)=> ',
	:PROMPT_S => '%N(%03n:%l)=> '
}
IRB.conf[:PROMPT_MODE] = :AGGREGATOR

begin
	require 'awesome_print'
	AwesomePrint.irb!
rescue LoadError => e
	warn "Couldn't load awesome_print: #{e}"
end

def moh!
	"quaaaak! .. and now, back to work!"
end