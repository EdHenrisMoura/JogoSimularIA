extends Control

@onready var botoes = $Botoes/BotInfo
@onready var texto = $Texto
@onready var voltar = $Voltar
@onready var voltar_menu = $VoltarMenu  # Referência ao botão VoltarMenu

# Estado inicial dos botões para restaurar depois
var estado_inicial_botoes = []

func _ready():
	# Salva o estado inicial dos botões (visibilidade)
	for botao in botoes.get_children():
		estado_inicial_botoes.append(botao.visible)
		# Corrige a conexão do sinal usando Callable
		botao.connect("pressed", Callable(self, "_on_botao_pressionado").bind(botao.name))
	
	# Conecta o botão de voltar
	voltar.connect("pressed", Callable(self, "_on_voltar_pressionado"))

	# Conecta o botão VoltarMenu
	voltar_menu.connect("pressed", Callable(self, "_on_voltar_menu_pressionado"))

# Quando um botão é pressionado
func _on_botao_pressionado(botao_name: String) -> void:
	# Define o texto correspondente
	match botao_name:
		"TreiSup":
			texto.text = "fase 1 - O treinamento supervisionado é a base para o aprendizado do robô no jogo, onde o jogador atua como um professor, fornecendo comandos explícitos para ensinar como realizar tarefas específicas. Esse método simula o funcionamento do aprendizado supervisionado em IA, no qual um modelo é treinado com dados rotulados para identificar padrões e realizar previsões. No contexto do jogo, o robô aprende a responder a comandos como pegar o objeto ou ir até a bola, replicando como um algoritmo supervisionado utiliza exemplos rotulados para melhorar seu desempenho."
		"Map":
			texto.text = "fase 1 - O mapeamento permite que o robô identifique e registre a posição de objetos e locais de interação no ambiente. Essa habilidade é inspirada em técnicas de IA como SLAM (Simultaneous Localization and Mapping), amplamente utilizada em robôs autônomos para criar mapas do ambiente enquanto se localizam. No jogo, o robô pode usar o mapeamento para navegar em um espaço desconhecido, associando posições a tarefas específicas. Essa etapa ajuda a ensinar conceitos de representação espacial e percepção ambiental, fundamentais para sistemas autônomos."
		"PlanSeq":
			texto.text = "fase 1 - O planejamento sequencial ensina ao robô como executar uma série de tarefas em uma ordem lógica, refletindo o conceito de planejamento em IA. Essa habilidade permite que o robô construa estratégias para atingir objetivos complexos, como buscar um objeto e entregá-lo em um local específico. No jogo, os alunos experimentam a criação de sequências otimizadas de ações, reforçando o entendimento de como os sistemas baseados em IA planejam e organizam etapas para alcançar resultados."
		"Classi":
			texto.text = "fase 2 - No processo de classificação, o robô aprende a associar objetos a suas características, como uma bola é redonda ou chave. Esse conceito é fundamental no aprendizado de máquina supervisionado, onde algoritmos aprendem a categorizar dados com base em exemplos fornecidos. No jogo, os jogadores introduzem atributos para treinar o robô a diferenciar objetos, compreendendo como os sistemas de IA categorizam informações para tomar decisões mais precisas."
		"CondBul":
			texto.text = "fase 2 - As condicionais e a lógica booleana ensinam ao robô a tomar decisões com base em condições predefinidas, como se houver um obstáculo, então deve desviar. Esse aprendizado reflete o uso de operadores lógicos em sistemas computacionais e é essencial para a tomada de decisões em IA. No jogo, os alunos criam regras que direcionam o comportamento do robô, entendendo como a lógica condicional estrutura o processo de decisão de máquinas."
		"LacRep":
			texto.text = "fase 3 - Os laços de repetição ensinam ao robô a executar tarefas repetitivas de forma eficiente, como buscar várias bolas e colocá-las em locais diferentes. Esse conceito é inspirado em estruturas de controle de fluxo, amplamente utilizadas em programação e aprendizado por reforço. No jogo, os jogadores utilizam loops para otimizar as ações do robô, entendendo como tarefas repetitivas são gerenciadas por algoritmos em cenários do mundo real."
		"Agrup":
			texto.text = "fase 4 - O agrupamento, ou clustering, permite que o robô organize objetos em grupos com base em suas semelhanças, sem a necessidade de instruções precisas. Esse conceito é um exemplo clássico de aprendizado não supervisionado, onde os algoritmos encontram padrões e estruturas em dados não rotulados. No jogo, os alunos observam como o robô identifica categorias, como agrupar bolas por cor, explorando como a IA descobre relações sem assistência direta."
		"TomDeci":
			texto.text = "fase 5 - A tomada de decisão otimizada permite que o robô escolha a melhor ação com base em condições e preferências, simulando o uso de algoritmos de otimização e aprendizado por reforço. No jogo, os jogadores orientam o robô a avaliar opções, priorizar tarefas e atingir objetivos, entendendo como sistemas de IA tomam decisões em cenários complexos, como em recomendações personalizadas ou sistemas de controle."
		_:
			texto.text = "Texto não definido"
	
	# Esconde todos os botões
	for botao in botoes.get_children():
		botao.visible = false

	# Mostra o texto
	texto.visible = true

# Quando o botão Voltar é pressionado
func _on_voltar_pressionado() -> void:
	# Restaura os botões para o estado inicial
	for i in range(botoes.get_child_count()):
		botoes.get_child(i).visible = estado_inicial_botoes[i]

	# Esconde o texto
	texto.visible = false
	texto.text = ""

# Quando o botão VoltarMenu é pressionado
func _on_voltar_menu_pressionado() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menu.tscn")
