extends CanvasLayer
var comando_sequencia = []  # Lista para armazenar a sequência de comandos


func _on_button_andar_pressed():
	comando_sequencia.append("andar")
	atualizar_caixa_comandos()

# Função para atualizar a caixa de comandos com a sequência atual
func atualizar_caixa_comandos():
	var texto = String(", ").join(comando_sequencia)
	$CaixaMeio/Comandos.text = texto
	print("Sequência de comandos atualizada: " + texto)

func _on_button_bola_pressed():
	comando_sequencia.append("bola")
	atualizar_caixa_comandos()
	

# Função para limpar a sequência de comandos ao pressionar o botão "resetarComandos"
func _on_resetar_comandos_pressed():
	comando_sequencia.clear()  # Limpa a lista de comandos
	$CaixaMeio/Comandos.text = " "

func _on_button_pegar_pressed():
	comando_sequencia.append("pegar")
	atualizar_caixa_comandos()


func _on_button_largar_pressed():
	comando_sequencia.append("largar")
	atualizar_caixa_comandos()



func _on_button_circulo_pressed():
	comando_sequencia.append("circulo")
	atualizar_caixa_comandos()


func _on_button_chave_pressed():
	comando_sequencia.append("chave")
	atualizar_caixa_comandos()

func _on_button_fechadura_pressed():
	comando_sequencia.append("fechadura")
	atualizar_caixa_comandos()
	
func _on_button_agrupar_pressed():
	comando_sequencia.append("agrupar")
	atualizar_caixa_comandos()
	



func _on_button_trabalhar_pressed():
	comando_sequencia.append("trabalhar")
	atualizar_caixa_comandos()
