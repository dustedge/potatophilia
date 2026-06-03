extends Panel
class_name NewsGenerator

func random_percent():
	return "%d%%" % randi_range(3, 25)
	

var templates = [
	"[LOCATION] [AUTHORITY] [ACTION] [SUBJECT]",
	"[SUBJECT] hits [ADJECTIVE] levels in [LOCATION]",
	"[AUTHORITY] warn of [ADJECTIVE] [SUBJECT]",
	"[SUBJECT] rises by [NUMBER] amid [EVENT]",
	"[AUTHORITY] announce [EVENT] affecting [SUBJECT]",
	"[AUTHORITY] divided over [SUBJECT]",
	"[EVENT] sparks debate among [AUTHORITY]",
	"[AUTHORITY] clash over [SUBJECT] in [LOCATION]",
	"[SUBJECT] under scrutiny after [EVENT]",
	"[SUBJECT] sees [ADJECTIVE] growth in [LOCATION]",
	"[LOCATION] experiences surge in [SUBJECT]",
	"[SUBJECT] market reacts to [EVENT]",
	"[AUTHORITY] predict [ADJECTIVE] future for [SUBJECT]",
	"[SUBJECT] clarity expected to [TREND] after [EVENT]",
	"[AUTHORITY] issue warning over [SUBJECT]",
	"[EVENT] threatens [SUBJECT] in [LOCATION]",
	"[SUBJECT] crisis worsens amid [EVENT]",
	"[ADJECTIVE] shortage of [SUBJECT] reported in [LOCATION]",
	"[AUTHORITY] discover [ADJECTIVE] method for [SUBJECT]",
	"New study reveals [EVENT] impacts [SUBJECT]",
	"[AUTHORITY] develop breakthrough in [SUBJECT]",
	"[SUBJECT] evolution linked to [EVENT], say [AUTHORITY]",
	"[AUTHORITY] confirm [ADJECTIVE] behavior in [SUBJECT]",
	"[SUBJECT] begins to [VERB], alarming [AUTHORITY]",
	"[EVENT] leads to unexpected [SUBJECT] boom",
	"[AUTHORITY] baffled by [ADJECTIVE] [SUBJECT]",
	"[SUBJECT] trend spreads rapidly across [LOCATION]",
	"[LOCATION] [AUTHORITY] reject [SUBJECT] ever taking place",
	"[AUTHORITY] in [LOCATION] [ACTION] [SUBJECT]",
	"[LOCATION] reports [ADJECTIVE] [SUBJECT]",
	"[ADJECTIVE] [SUBJECT] situation reported in [LOCATION]",
	"[AUTHORITY] confused by [ADJECTIVE] [SUBJECT] activity",
	"[LOCATION] declares emergency over [SUBJECT]",
	"[AUTHORITY] artificers unveil [ADJECTIVE] [SUBJECT]",
	"[AUTHORITY] guild completes [ADJECTIVE] upgrade to [SUBJECT]",
	"[AUTHORITY] guild strikes over [SUBJECT] in [LOCATION]",
	"[LOCATION] artisans report shortage of [SUBJECT]",
	"[LOCATION] blames [AUTHORITY] for [SUBJECT] failure",
	"[SUBJECT] corruption spreads across [LOCATION]",
	"[AUTHORITY] mobilize response to [SUBJECT] crisis",
	"warlock interference reported in [SUBJECT] systems",
	"arcane overload causes [ADJECTIVE] [SUBJECT] behavior",
	"[AUTHORITY] unable to explain [ADJECTIVE] [SUBJECT] anomalies",
	"study confirms link between [EVENT] and [SUBJECT]",
	"new theory explains [SUBJECT] behavior in [LOCATION]",
	"historical records show rise of [SUBJECT] after [EVENT]",
	]
	
var locations = [
	"Kekistan",
	"Rural disctricts",
	"Agricultural regions",
	"Northern territories",
	"Eastern provinces",
	"Coastal markets",
	"Underground farming zones",
	"Southern Swamps",
	"Regaland",
	"Modern Rome",
	"Republic of Raine",
	"Southern Elvish villages",
	"Ork colonies",
	"Northern Elvish villages",
	"Dwarven Stronghold",
	"Western Goblin tribe",
	"Fae Realm",
	"Manabloom Grove",
	"Magnitoshakhtinks",
	"Titanic plains",
	"Fae's overpass",
	"Alipheese XIX's lane",
	"International Seed Bank",
	"Ohio",
	"The Void"
]

@onready var main : Main = get_parent().get_parent().get_parent();

var authorities = [
	"Farmers",
	"Local farmers",
	"Agricultural experts",
	"Officials",
	"Government officials",
	"Scientists",
	"Researchers",
	"Economists",
	"Market analysts",
	"Industry leaders",
	"Trade unions",
	"Farming cooperatives",
	"Regulatory agencies",
	"Wizards",
	"Adventurers",
	"Nobles",
	"Magic researchers",
	"Artificers",
	"Archmages",
	"Residents",
	"Beggars",
	"Thieves",
	"Vulpheline officials",
	"Vulpheline researchers",
	"Cinq Western Association", 
	"Moles", 
	"Professional Hobo Squad Leaders", 
	"The Hero", 
	"Sproinkers Commanders", 
	"Goblin thieves",
	"Monster Lords council",
]

var actions = [
	"celebrate",
	"investigate",
	"question",
	"announce",
	"confirm",
	"deny",
	"monitor",
	"predict",
	"criticize",
	"cancel",
	"support",
	"regulate",
	"expand",
	"shrink",
	"defend",
	"struggle with",
	"leave",
	"return",
	"succeed",
]

var subjects = [
	"potato production",
	"potato supply",
	"potato demand",
	"potato prices",
	"crop yields",
	"farming output",
	"harvest quality",
	"DNA modification",
	"magic eruption",
	"series of confetti explosions",
	"sandwich terrorist attack",
	"undetermined flying object",
	"anomalous plant growth",
	"monster population",
	"dragon migration",
	"experimental research",
	"golem uprising",
	"automated farming systems",
	"export volumes",
	"import volumes",
	"storage capacity",
	"farming efficiency",
	"Goblin riot",
	"major monster attacks",
	"processed potato goods",
	"Dwarven technology",
	"Elvish house building",
	"Halfling feet hair",
	"magical enhancements of fast food",
	"intervention in research processes",
	"Horse semen uses in food production",
	"cannibalism as a solution to starvation",
	"assbug invasion", 
	"thought recycling", 
	"Space Mining Program", 
	"Kibbles monument", 
	"Femboy hooters", 
	]
	
var events = [
	"record breaking harvest",
	"unexpected drought",
	"opposition attack",
	"policy changes",
	"severe weather",
	"magic tornado strikes",
	"market fluctuations",
	"rising demand",
	"labor shortages",
	"technological breakthrough",
	"trade agreement",
	"export restrictions",
	"economic downturn",
	"automation boom",
	"genetic modification breakthrough",
	"time anomaly",
	"dimensional instability",
	"rift spawn",
	"return of the microscopic black hole",
	]
	
var adjectives = [
	"significant",
	"moderate",
	"steady",
	"gradual",
	"unexpected",
	"temporary",
	"severe",
	"critical",
	"alarming",
	"dramatic",
	"sharp",
	"unprecedented",
	"unusual",
	"mysterious",
	"unstable",
	"anomalous",
	"exponential",
	"reality-defying"
]

var trends = [
	"rise",
	"fall",
	"stabilize",
	"decline",
	"surge",
	"fluctuate",
	"collapse",
	"recover"
]

var verbs = [
	"grow",
	"expand",
	"spread",
	"evolve",
	"mutate",
	"multiply",
	"stabilize",
	"destabilize",
	"self-replicate",
	"transcend",
	"undergo",
	"cross",
	"laugh",
	"facilitate",
	"charge",
	"interrupt"
]
	
var keys = [
	"[ADJECTIVE]",
	"[LOCATION]",
	"[AUTHORITY]",
	"[ACTION]",
	"[EVENT]",
	"[SUBJECT]",
	"[TREND]",
	"[VERB]",
	"[NUMBER]"
];

var news_label_scene : PackedScene = preload("res://scenes/news_label.tscn")

func _ready() -> void:
	$NewsTimer.start()
				

func spawn_random_headline():
	var headline : String = templates.pick_random()
	for key in keys:
		if key in headline:
			match key:
				"[ADJECTIVE]": headline = headline.replace("[ADJECTIVE]", adjectives.pick_random())
				"[LOCATION]": headline = headline.replace("[LOCATION]", locations.pick_random())
				"[AUTHORITY]": headline = headline.replace("[AUTHORITY]", authorities.pick_random())
				"[ACTION]": headline = headline.replace("[ACTION]", actions.pick_random())
				"[EVENT]": headline = headline.replace("[EVENT]", events.pick_random())
				"[SUBJECT]": headline = headline.replace("[SUBJECT]", subjects.pick_random())
				"[TREND]": headline = headline.replace("[TREND]", trends.pick_random()) 
				"[VERB]": headline = headline.replace("[VERB]", verbs.pick_random())
				"[NUMBER]": headline = headline.replace("[NUMBER]", random_percent())
				
	var news_entry : Label = news_label_scene.instantiate();
	headline[0] = headline[0].to_upper()
	
	if randi_range(0, 100) >= 90: headline = "BREAKING: " + headline
	
	headline = "["+ main.get_date_string()+"] " + headline
	
	
	
	news_entry.text = headline
	self.add_child(news_entry)
	Globals.add_log_entry(headline)


func _on_news_timer_timeout() -> void:
	spawn_random_headline()
	$NewsTimer.wait_time = randf_range(8,20)
	$NewsTimer.start()
