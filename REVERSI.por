programa
{
	// Bibliotecas
	inclua biblioteca Arquivos --> arq
	inclua biblioteca Graficos --> grf
	inclua biblioteca Mouse --> mse
	inclua biblioteca Teclado --> tcl
	inclua biblioteca Texto --> txt
	inclua biblioteca Tipos --> tps
	inclua biblioteca Util --> utl

	// Constantes que amazenam valores das janelas
	const inteiro LARGURA_MENU = 500, ALTURA_MENU = 318
	const inteiro LARGURA_JOGO = 1024, ALTURA_JOGO = 710

	// Constantes que amazenam os textos do jogo
	const cadeia TITULO = "REVERSI THE GAME"

	// Variáveis que amazenam as imagens do jogo
	inteiro imagem_fundo_menu = 0, imagem_humano_IA = 0, imagem_creditos = 0, imagem_tabuleiro = 0, imagem_ficha_branca = 0
	inteiro imagem_ficha_preta = 0, imagem_ficha_preta1 = 0, imagem_ficha_branca1 = 0, imagem_texto_branco = 0, imagem_texto_preto = 0
	inteiro imagem_saudacao = 0, imagem_texto_humano = 0, imagem_texto_IA = 0,imagem_x = 0,imagem_pressEnter = 0
	inteiro imagem_0 = 0, imagem_1 = 0, imagem_2 = 0, imagem_3 = 0, imagem_4 = 0,imagem_5 = 0, imagem_6 = 0, imagem_7 = 0, imagem_8 = 0, imagem_9 = 0
	inteiro imagem_pretas = 0 , imagem_brancas = 0, contadorp = 0 , contadorb = 0

	// Variáveis que armazenam valores sobre a matriz e qualquer coisa relacionada as regras
	inteiro matriz_posicao[8][8]		// Matriz principal que armazena as peças. 0: VAZIO; 1: PRETAS; 2: BRANCAS
	inteiro posicao_i, posicao_j
	inteiro click_x, click_y
	inteiro auxiliar, auxiliar2 = 0, pecas_roubadas
	inteiro numero_de_jogadas = 1, melhor_jogada_i = 0, melhor_jogada_j = 0
	logico pecas_proprias = falso, pecas_inimigas = falso
	logico jogada_realizada_vertical = falso, jogada_realizada_horizontal = falso, jogada_realizada_diagonal_principal = falso, jogada_realizada_diagonal_secundaria = falso

	//
	// Essa é a função principal no qual todo jogo será executado
	//
	funcao inicio()
	{
		carregar_imagens()
		inicializar()
		menu()			
		finalizar()
	}

	//
	// Essa parte trata de desenhar o menu principal e todos os elementos dele
	//

	// Função que desenha o menu principal
	funcao menu()
	{
		// Os laços seguram as telas durante o jogo 
		enquanto(verdadeiro){
			grf.desenhar_imagem(0, 0, imagem_fundo_menu)

			// Verifica a posição do mouse e desenha uma caixa transparente para as opções, caso clique redireciona para a proxima tela
			escolher_opcao()
		}
	}

	// Validar escolhas do menu principal
	funcao escolher_opcao()
	{
		// Cria caixa transparente sobre o nome "Novo Jogo" no menu
		se(mse.posicao_x() >= 172 e mse.posicao_x() <= 328 e mse.posicao_y() >= 143.8 e mse.posicao_y() <= 168.8){
			grf.definir_cor(grf.COR_PRETO)
			grf.definir_opacidade(100)
			grf.desenhar_retangulo(172, tps.real_para_inteiro(143.8), 156, 25, falso, verdadeiro)

			// Isso redireciona para tela de escolha de humanos ou maquinas caso seja clicado
			se(mse.botao_pressionado(mse.BOTAO_ESQUERDO)){
					escolher_versus()
			}
		}
		// Cria caixa transparente sobre o nome "Carregar" no menu
		se(mse.posicao_x() >= 170 e mse.posicao_x() <= 331 e mse.posicao_y() >= 173 e mse.posicao_y() <= 198){
			grf.definir_cor(grf.COR_PRETO)
			grf.definir_opacidade(100)
			grf.desenhar_retangulo(170, 173, 161, 25, falso, verdadeiro)

			// Isso carrega o jogo caso seja clicado
			se(mse.botao_pressionado(mse.BOTAO_ESQUERDO)){

			}
		}
		// Cria caixa transparente sobre o nome "Creditos" no menu
		se(mse.posicao_x() >= 182 e mse.posicao_x() <= 318 e mse.posicao_y() >= 203 e mse.posicao_y() <= 228){
			grf.definir_cor(grf.COR_PRETO)
			grf.definir_opacidade(100)
			grf.desenhar_retangulo(182, 203, 136, 25, falso, verdadeiro)

			// Isso redireciona para a tela de creditos caso seja clicado
			se(mse.botao_pressionado(mse.BOTAO_ESQUERDO)){
				escolher_creditos()
			}
		}
		// Cria caixa transparente sobre o nome "Sair" no menu
		se(mse.posicao_x() >= 214 e mse.posicao_x() <= 283 e mse.posicao_y() >= 233 e mse.posicao_y() <= 258){
			grf.definir_cor(grf.COR_PRETO)
			grf.definir_opacidade(100)
			grf.desenhar_retangulo(214, 233, 69, 25, falso, verdadeiro)

			// Isso fecha o jogo caso seja clicado
			se(mse.botao_pressionado(mse.BOTAO_ESQUERDO)){
				saudacao()
			}
		}
		grf.renderizar()
	}

	// Carrega a tela de créditos
	funcao escolher_creditos()
	{
		enquanto(verdadeiro){
			// Desenha os créditos caso seja escolhido a opção no menu
			grf.definir_opacidade(255)
			grf.desenhar_imagem(0, 0, imagem_creditos)
			
			// Volta para a primeira tela caso pressionaa ESC
			se(tcl.tecla_pressionada(tcl.TECLA_ESC)){
				menu()
			}
			grf.renderizar()
		}
	}

	// Humano ou maquina
	funcao escolher_versus()
	{
		enquanto(verdadeiro){
			// Desenha a nova tela caso clique em novo jogo
			grf.definir_opacidade(255)
			grf.desenhar_imagem(0, 0, imagem_humano_IA)

			// Cria uma caixa transparente sobre alguma escolha
			se(mse.posicao_x() >= 0 e mse.posicao_x() < 250 e mse.posicao_y() >= 50 e mse.posicao_y() <= 300){
				grf.definir_cor(grf.COR_PRETO)
				grf.definir_opacidade(100)
				grf.desenhar_retangulo(0, 50, 250, 250, falso, verdadeiro)
				grf.definir_opacidade(255)
				grf.definir_cor(grf.COR_BRANCO)
				grf.definir_estilo_texto(falso, verdadeiro, falso)
				grf.definir_tamanho_texto(25.0)
				grf.desenhar_texto(35, 155, "MULTIPLAYER")
				grf.definir_opacidade(255)

				// Inicia partida contra outro humano caso seja clicado
				se(mse.botao_pressionado(mse.BOTAO_DIREITO)){
					grf.encerrar_modo_grafico()
					limpa()
					utl.aguarde(500)
					jogo_multiplayer()
				}
			}
			// Cria uma caixa transparente sobre alguma escolha
			se(mse.posicao_x() > 250 e mse.posicao_x() <= 500 e mse.posicao_y() >= 50 e mse.posicao_y() <= 300){
				grf.definir_cor(grf.COR_PRETO)
				grf.definir_opacidade(100)
				grf.desenhar_retangulo(250, 50, 250, 250, falso, verdadeiro)
				grf.definir_opacidade(255)
				grf.definir_cor(grf.COR_BRANCO)
				grf.definir_estilo_texto(falso, verdadeiro, falso)
				grf.definir_tamanho_texto(25.0)
				grf.desenhar_texto(303, 155, "CONTRA IA")
				grf.definir_opacidade(255)

				// Inicia partida contra a IA caso clicado
				se(mse.botao_pressionado(mse.BOTAO_DIREITO)){
					utl.aguarde(500)
					jogo_IA()
				}
			}

			// Volta para a primeira tela caso pressiona ESC
			se(tcl.tecla_pressionada(tcl.TECLA_ESC)){
				menu()
			}
			grf.renderizar()
		}
	}
	
	//
	// Essa parte trata dos modos de jogo
	//

	funcao jogo_multiplayer()
	{
		// Fecha o menu e abre o tabuleiro
		inicializar_jogo()
	
		// Desenha o tabuleiro
		tabuleiro()

		// Desenha o jogador da vez inicialmente
		se(numero_de_jogadas == 1){
			grf.desenhar_imagem(1, 661, imagem_ficha_preta1)
			grf.desenhar_imagem(50, 660, imagem_texto_preto)
		}
		
		// Atribui a posição das peças iniciais à matriz posição
		posicao_inicial()
			pecas()
		// Faz a primeira renderizada
		grf.renderizar()

		enquanto(verdadeiro){
			mse.ler_botao()
			// Pegar as cordenadas
			click_x = mse.posicao_x()
			click_y = mse.posicao_y()
			
			// Verifica se clicou dentro do tabuleiro e se a jogada é do preto ou branco
			se(click_x > 30 e click_x < 630 e click_y > 30 e click_y < 630){
				// Calcula o indice da matriz posicao
				posicao_i = (click_y-30)/75
				posicao_j = (click_x-30)/75
				
				// Vez do jogador preto
				se(numero_de_jogadas % 2 !=0 ){
					
						// Desenha jogador da vez
					grf.desenhar_imagem(1, 661, imagem_ficha_branca1)
					grf.desenhar_imagem(50, 660, imagem_texto_branco)
					grf.renderizar()
					
					// Verifica se a posião clicada não possui peca
					jogadas_multiplayer()
					//invoca funcão que conta e exibe a qtd de peças
					pecas()
					
					// Verifica se a jogada foi realizada
					se(jogada_realizada_vertical ou jogada_realizada_horizontal ou jogada_realizada_diagonal_principal ou jogada_realizada_diagonal_secundaria){
						numero_de_jogadas++
						
						
						
					}
						
						
				}
				// Vez do jogador branco
				senao{
									
					// Desenha jogador da vez
					grf.desenhar_imagem(1, 661, imagem_ficha_preta1)
					grf.desenhar_imagem(50, 660, imagem_texto_preto)
					grf.renderizar()
					// verifica se a posião clicada não possui peca
					jogadas_IA()
					//invoca funcão que conta e exibe a qtd de peças
					pecas()
					
					// verifica se a jogada foi realizada
					se(jogada_realizada_vertical ou jogada_realizada_horizontal ou jogada_realizada_diagonal_principal ou jogada_realizada_diagonal_secundaria){
						numero_de_jogadas++
											
					}
				}
			}
			// Trata das escolhas durante o tabuleiro
			senao{
				// Caso click em dicas
				se(click_x > 700 e click_x < 995 e click_y > 330 e click_y < 425){
					
				}
				// Caso click em salvar jogo
				senao se(click_x > 700 e click_x < 995 e click_y > 430 e click_y < 525){
					
				}
				
				senao se(click_x > 700 e click_x < 995 e click_y > 530 e click_y < 625){
					grf.encerrar_modo_grafico()
					inicializar()
					menu()	
				}
			}
		}
	}

	funcao jogo_IA()
	{
		// Fecha o menu e abre o tabuleiro
		inicializar_jogo()
	
		// Desenha o tabuleiro
		tabuleiro()

		// Desenha o jogador da vez inicialmente
		se(numero_de_jogadas == 1){
			grf.desenhar_imagem(1, 661, imagem_ficha_preta1)
			grf.desenhar_imagem(50, 660, imagem_texto_humano)
		}
		
		// Atribui a posição das peças iniciais à matriz posição
		posicao_inicial()
		
		// Faz a primeira renderizada
		grf.renderizar()
		
		enquanto(verdadeiro){		
			// Vez do jogador preto
			se(numero_de_jogadas % 2 !=0 ){
				// Desenha jogador da vez
				grf.desenhar_imagem(1, 661, imagem_ficha_branca1)
				grf.desenhar_imagem(50, 660, imagem_texto_IA)
				
				mse.ler_botao()
				// Pegar as cordenadas
				click_x = mse.posicao_x()
				click_y = mse.posicao_y()

				// Verifica se clicou dentro do tabuleiro e se a jogada é do preto ou branco
				se(click_x > 30 e click_x < 630 e click_y > 30 e click_y < 630){	
					// Calcula o indice da matriz posicao
					posicao_i = (click_y-30)/75
					posicao_j = (click_x-30)/75
						
					// Verifica se a posião clicada não possui peca
					se(matriz_posicao[posicao_i][posicao_j] == 0){
						jogadas_multiplayer()
						// Verifica se a jogada foi realizada
						se(jogada_realizada_vertical ou jogada_realizada_horizontal ou jogada_realizada_diagonal_principal ou jogada_realizada_diagonal_secundaria){
							numero_de_jogadas++
						}
					}
				}
				// Trata das escolhas durante o tabuleiro
				senao{
					// Caso click em dicas
					se(click_x > 700 e click_x < 995 e click_y > 330 e click_y < 425){
					
					}
					// Caso click em salvar jogo
					senao se(click_x > 700 e click_x < 995 e click_y > 430 e click_y < 525){
					
					}
				
					senao se(click_x > 700 e click_x < 995 e click_y > 530 e click_y < 625){
						grf.encerrar_modo_grafico()
						numero_de_jogadas = 1
						inicializar()
						menu()	
					}
				}	
			}

			// Vez do jogador branco
			senao{
				// Desenha jogador da vez
				grf.desenhar_imagem(1, 661, imagem_ficha_preta1)
				grf.desenhar_imagem(50, 660, imagem_texto_humano)
				
				// identifica a jogada que captura o maior numero de peças do oponente
				melhor_jogada()
				posicao_i = melhor_jogada_i
				posicao_j = melhor_jogada_j

				grf.desenhar_imagem(posicao_j*75 + 57, posicao_i*75 + 50 , imagem_x)
				grf.desenhar_imagem(1, 661, imagem_ficha_branca1)
				grf.desenhar_imagem(50, 660, imagem_texto_IA)
				
				grf.desenhar_imagem(400, 660, imagem_pressEnter)
				grf.renderizar()
						
				se(tcl.tecla_pressionada(tcl.TECLA_ENTER)){
					jogadas_IA()
					numero_de_jogadas++	
					grf.desenhar_imagem(1, 661, imagem_ficha_preta1)
					grf.desenhar_imagem(50, 660, imagem_texto_humano)
					grf.definir_cor(grf.COR_PRETO)
					grf.desenhar_retangulo(400, 660, 200, 50, falso, verdadeiro)
					grf.renderizar()
				}			
				// Trata das escolhas durante o tabuleiro
				se(mse.posicao_x() > 630 e mse.posicao_y() > 0){
					mse.ler_botao()
					// Pegar as cordenadas
					click_x = mse.posicao_x()
					click_y = mse.posicao_y()
					
					// Caso click em dicas
					se(click_x > 700 e click_x < 995 e click_y > 330 e click_y < 425){
					
					}
					// Caso click em salvar jogo
					senao se(click_x > 700 e click_x < 995 e click_y > 430 e click_y < 525){
					
					}
				
					senao se(click_x > 700 e click_x < 995 e click_y > 530 e click_y < 625){
						grf.encerrar_modo_grafico()
						numero_de_jogadas = 1
						inicializar()
						menu()	
					}
				}
			}
		}
	}

	//
	// Essa parte trata das matrizes e das regras a serem aplicadas no jogo
	//

	// Valida as jogadas e vira a peça 
	funcao jogadas_multiplayer()
	{
		// Funções das jogadas
		vertical()
		horizontal()
		diagonal_principal()
		diagonal_secundaria()
	}

	// Valida as jogadas e vira a peça 
	funcao jogadas_IA()
	{
		vertical_branco(verdadeiro)
		horizontal_branco(verdadeiro)
		diagonal_principal_branco(verdadeiro)
		diagonal_secundaria_branco(verdadeiro)
	}

	// Valida as jogadas na vertical
	funcao vertical()
	{
		// Verifica se a jogada é possivel
						
		// Verificação vertical acima de onde clicou		
		
		pecas_proprias = falso
		jogada_realizada_vertical = falso
		pecas_inimigas = verdadeiro
		
		// Verifica se existe uma peça preta acima de onde clicou
		para(inteiro i = posicao_i - 2; i >= 0; i--){
			se(matriz_posicao[i][posicao_j] == 1){	
				pecas_proprias = verdadeiro
				auxiliar = i
				pare 
			}
		}
		
		// Verifica se as peças entre onde clicou e a preta acima são todas brancas
		se(pecas_proprias == verdadeiro){
			para(inteiro i = posicao_i-1; i > auxiliar; i--){
				se(matriz_posicao[i][posicao_j] != 2){
					pecas_inimigas = falso
					pare
				}
			}
		}
		
		// Se as condiçõe acima forem satisfeitas a jogada é realizada
		se(pecas_proprias == verdadeiro e pecas_inimigas == verdadeiro){
			para(inteiro i = posicao_i; i > auxiliar; i--){
				matriz_posicao[i][posicao_j] = 1
				grf.desenhar_imagem(posicao_j*75 + 32, i*75 + 31, imagem_ficha_preta)
				grf.renderizar()		
			}
			jogada_realizada_vertical=verdadeiro
		}
		
		// Verificação vertical abaixo de onde clicou		
		
		pecas_proprias = falso
		pecas_inimigas = verdadeiro
		
		// Verifica se existe uma peça preta abaixo de onde clicou
		para(inteiro i = posicao_i + 2; i <= 7; i++){
			se(matriz_posicao[i][posicao_j] == 1){	
				pecas_proprias = verdadeiro
				auxiliar = i
				pare
			}
		}
		
		// Verifica se as peças entre onde clicou e a preta acima são todas brancas
		se(pecas_proprias == verdadeiro){
			para(inteiro i = posicao_i + 1; i < auxiliar; i++){
				se(matriz_posicao[i][posicao_j] != 2){
					pecas_inimigas=falso
					pare
				}
			}
		}
		
		// Se as condiçõe acima forem satisfeitas a jogada é realizada
		se(pecas_proprias == verdadeiro e pecas_inimigas == verdadeiro){
			para(inteiro i = posicao_i; i < auxiliar; i++){
				matriz_posicao[i][posicao_j] = 1
				grf.desenhar_imagem(posicao_j*75 + 32, i*75 + 31, imagem_ficha_preta)
				grf.renderizar()		
			}
			jogada_realizada_vertical = verdadeiro
		}
	}

	// Valida as jogadas na horizontal
	funcao horizontal()
	{
		// Verifica se a jogada é possivel
						
		// Verificação horizontal a esquerda de onde clicou		
		
		pecas_proprias = falso
		jogada_realizada_horizontal = falso
		pecas_inimigas = verdadeiro
		
		// Verifica se existe uma peça preta a esquerda de onde clicou
		para(inteiro j= posicao_j - 2; j >= 0; j--){
			//escreva("teste")
			se(matriz_posicao[posicao_i][j] == 1){	
				pecas_proprias = verdadeiro
				auxiliar = j
				pare
			}
		}
		
		// Verifica se as peças entre onde clicou e a preta a esquerda são todas brancas
		se(pecas_proprias == verdadeiro){
			para(inteiro j = posicao_j - 1; j > auxiliar ; j--){
				se(matriz_posicao[posicao_i][j] != 2){
					pecas_inimigas = falso
					pare
				}
			}
		}
		
		// Se as condiçõe acima forem satisfeitas a jogada é realizada
		se(pecas_proprias == verdadeiro e pecas_inimigas == verdadeiro){
			para(inteiro j = posicao_j; j > auxiliar; j--){
				matriz_posicao[posicao_i][j] = 1
				grf.desenhar_imagem(j*75 + 32, posicao_i*75 + 31, imagem_ficha_preta)
				grf.renderizar()
			}
			jogada_realizada_horizontal=verdadeiro
		}
		
		// Verificação horizontal a direita de onde clicou		
		
		pecas_proprias = falso
		pecas_inimigas = verdadeiro
		
		// Verifica se existe uma peça preta a direita de onde clicou
		para(inteiro j = posicao_j + 2; j <= 7; j++){
			se(matriz_posicao[posicao_i][j] == 1){	
				pecas_proprias = verdadeiro
				auxiliar = j
				pare
			}
		}
		
		// Verifica se as peças entre onde clicou e a preta a direita são todas brancas
		se(pecas_proprias == verdadeiro){
			para(inteiro j = posicao_j + 1; j < auxiliar; j++){
				se(matriz_posicao[posicao_i][j] != 2){
					pecas_inimigas = falso
					pare
				}
			}
		}
		
		// Se as condiçõe acima forem satisfeitas a jogada é realizada
		se(pecas_proprias == verdadeiro e pecas_inimigas == verdadeiro){
			para(inteiro j = posicao_j; j < auxiliar; j++){
				matriz_posicao[posicao_i][j] = 1
				grf.desenhar_imagem(j*75 + 32, posicao_i*75 + 31, imagem_ficha_preta)
				grf.renderizar()
			}
			jogada_realizada_horizontal=verdadeiro
		}
	}

	// Valida as jogadas na diagonal
	funcao diagonal_principal()
	{
		// Verificação diagonal a esquerda de onde clicou		
		
		pecas_proprias = falso
		jogada_realizada_diagonal_principal=falso
		pecas_inimigas=verdadeiro

		// Verifica se existe uma peça preta na parte esquerda da diagonal principal de onde clicou
		para(inteiro k = 2; posicao_i - k >= 0 e posicao_j - k >= 0; k++){
			se(matriz_posicao[posicao_i-k][posicao_j-k] == 1){	
				pecas_proprias = verdadeiro
				auxiliar = k
				pare
			}
		}

		// Verifica se as peças entre onde clicou e a preta a esquerda são todas brancas
		se(pecas_proprias == verdadeiro){
			para(inteiro k = 1; k < auxiliar ; k++){
				se(matriz_posicao[posicao_i-k][posicao_j-k] != 2){
					pecas_inimigas = falso
					pare
				}	
			}
		}

		// Se as condiçõe acima forem satisfeitas a jogada é realizada
		se(pecas_proprias == verdadeiro e pecas_inimigas == verdadeiro){
			para(inteiro k = 0; k < auxiliar; k++){
				matriz_posicao[posicao_i-k][posicao_j-k] = 1
				grf.desenhar_imagem((posicao_j-k)*75 + 32, (posicao_i-k)*75 + 31, imagem_ficha_preta)
				grf.renderizar()
			}
			jogada_realizada_diagonal_principal = verdadeiro
		}

		// Verificação diagonal a direita de onde clicou		
		
		pecas_proprias = falso
		pecas_inimigas = verdadeiro

		// Verifica se existe uma peça preta na parte direita da diagonal principal de onde clicou
		para(inteiro k = 2; posicao_i + k <= 7 e posicao_j + k <= 7; k++){
			se(matriz_posicao[posicao_i+k][posicao_j+k] == 1){	
				pecas_proprias = verdadeiro
				auxiliar = k
				pare
			}
		}

		// Verifica se as peças entre onde clicou e a preta a esquerda são todas brancas
		se(pecas_proprias == verdadeiro){
			para(inteiro k = 1; k < auxiliar ; k++){
				se(matriz_posicao[posicao_i+k][posicao_j+k] != 2){
					pecas_inimigas = falso
					pare
				}	
			}
		}

		// Se as condiçõe acima forem satisfeitas a jogada é realizada
		se(pecas_proprias == verdadeiro e pecas_inimigas == verdadeiro){
			para(inteiro k = 0; k < auxiliar; k++){
				matriz_posicao[posicao_i+k][posicao_j+k] = 1
				grf.desenhar_imagem((posicao_j+k)*75 + 32, (posicao_i+k)*75 + 31, imagem_ficha_preta)
				grf.renderizar()	
			}
			jogada_realizada_diagonal_principal = verdadeiro
		}
	}

	// Valida as jogadas na diagonal
	funcao diagonal_secundaria()
	{
		// Verificação diagonal a esquerda de onde clicou		
		pecas_proprias = falso
		jogada_realizada_diagonal_secundaria = falso
		pecas_inimigas = verdadeiro

		// Verifica se existe uma peça preta na parte esquerda da diagonal secundaria de onde clicou
		para(inteiro k = 2; posicao_i + k <= 7 e posicao_j - k >= 0; k++){
			se(matriz_posicao[posicao_i+k][posicao_j-k] == 1){	
				pecas_proprias = verdadeiro
				auxiliar = k
				pare
			}
		}

		// Verifica se as peças entre onde clicou e a preta a esquerda são todas brancas
		se(pecas_proprias == verdadeiro){
			para(inteiro k = 1; k < auxiliar ; k++){
				se(matriz_posicao[posicao_i+k][posicao_j-k] != 2){
					pecas_inimigas = falso
					pare
				}	
			}
		}

		// Se as condiçõe acima forem satisfeitas a jogada é realizada
		se(pecas_proprias == verdadeiro e pecas_inimigas == verdadeiro){
			para(inteiro k = 0; k < auxiliar; k++){
				matriz_posicao[posicao_i+k][posicao_j-k] = 1
				grf.desenhar_imagem((posicao_j-k)*75 + 32, (posicao_i+k)*75 + 31, imagem_ficha_preta)
				grf.renderizar()
			}
			jogada_realizada_diagonal_secundaria=verdadeiro
		}

		// Verificação diagonal a direita de onde clicou		
		
		pecas_proprias = falso
		pecas_inimigas = verdadeiro

		// Verifica se existe uma peça preta na parte direita da diagonal secundaria de onde clicou
		para(inteiro k = 2; posicao_i - k >= 0 e posicao_j + k <= 7; k++){
			se(matriz_posicao[posicao_i-k][posicao_j+k] == 1){	
				pecas_proprias = verdadeiro
				auxiliar = k
				pare
			}
		}

		// Verifica se as peças entre onde clicou e a preta a direita são todas brancas
		se(pecas_proprias == verdadeiro){
			para(inteiro k = 1; k < auxiliar ; k++){
				se(matriz_posicao[posicao_i-k][posicao_j+k] != 2){
					pecas_inimigas = falso
					pare
				}	
			}
		}

		// Se as condiçõe acima forem satisfeitas a jogada é realizada
		se(pecas_proprias == verdadeiro e pecas_inimigas == verdadeiro){
			para(inteiro k = 0; k < auxiliar; k++){
				matriz_posicao[posicao_i-k][posicao_j+k] = 1
				grf.desenhar_imagem((posicao_j+k)*75 + 32, (posicao_i-k)*75 + 31, imagem_ficha_preta)
				grf.renderizar()
			}
			jogada_realizada_diagonal_secundaria=verdadeiro
		}
	}

	// Faz a verificação vertical da jogada e vira as peças possiveis na vertical
	funcao vertical_branco(logico flag)
	{
		// Verifica se a jogada é possivel
						
		// Verificação vertical acima de onde clicou		
		
		pecas_proprias = falso
		jogada_realizada_vertical = falso
		pecas_inimigas = verdadeiro
		
		// Verifica se existe uma peça branca acima de onde clicou
		para(inteiro i = posicao_i - 2; i >= 0; i--){
			se(matriz_posicao[i][posicao_j] == 2){	
				pecas_proprias = verdadeiro
				auxiliar = i
				pare
			}
		}
		
		// verifica se as peças entre onde clicou e a preta acima são todas brancas
		se(pecas_proprias == verdadeiro){
			para(inteiro i = posicao_i - 1; i > auxiliar; i--){
				se(matriz_posicao[i][posicao_j] != 1){
					pecas_inimigas = falso
					pare
				}
			}
		}
		
		// Se as condiçõe acima forem satisfeitas a jogada é realizada
		se(pecas_proprias == verdadeiro e pecas_inimigas == verdadeiro){
			para(inteiro i = posicao_i; i > auxiliar; i--){
				auxiliar2++
				se(flag){
					matriz_posicao[i][posicao_j] = 2
					grf.desenhar_imagem(posicao_j*75 + 32, i*75 + 31, imagem_ficha_branca)
					grf.renderizar()
				}
			}
			jogada_realizada_vertical=verdadeiro
		}
		
		// Verificação vertical abaixo de onde clicou		
		
		pecas_proprias = falso
		pecas_inimigas = verdadeiro
		
		// Verifica se existe uma peça branca abaixo de onde clicou
		para(inteiro i = posicao_i + 2; i <= 7; i++){
			se(matriz_posicao[i][posicao_j] == 2){	
				pecas_proprias = verdadeiro
				auxiliar = i
				pare
			}
		}
		
		// Verifica se as peças entre onde clicou e a preta acima são todas brancas
		se(pecas_proprias == verdadeiro){
			para(inteiro i = posicao_i + 1; i < auxiliar; i++){
				se(matriz_posicao[i][posicao_j] != 1){
					pecas_inimigas = falso
					pare
				}
			}
		}
		// Se as condiçõe acima forem satisfeitas a jogada é realizada
		se(pecas_proprias == verdadeiro e pecas_inimigas == verdadeiro){
			para(inteiro i = posicao_i; i < auxiliar; i++){
				auxiliar2++
				se(flag){
					matriz_posicao[i][posicao_j] = 2
					grf.desenhar_imagem(posicao_j*75 + 32, i*75 + 31, imagem_ficha_branca)
					grf.renderizar()
				}
			}
			jogada_realizada_vertical = verdadeiro
		}
	}

	// Faz a verificação horizontal da jogada e vira as peças possiveis na horizontal
	funcao horizontal_branco(logico flag)
	{
		// Verifica se a jogada é possivel
						
		// Verificação horizontal a esquerda de onde clicou		
		
		pecas_proprias = falso
		jogada_realizada_horizontal = falso
		pecas_inimigas = verdadeiro
		
		// Verifica se existe uma peça preta a esquerda de onde clicou
		para(inteiro j = posicao_j - 2; j >= 0; j--){
			se(matriz_posicao[posicao_i][j] == 2){	
				pecas_proprias = verdadeiro
				auxiliar = j
				pare
			}
		}
		
		// Verifica se as peças entre onde clicou e a preta a esquerda são todas brancas
		se(pecas_proprias == verdadeiro){
			para(inteiro j = posicao_j - 1; j > auxiliar; j--){
				se(matriz_posicao[posicao_i][j] != 1){
					pecas_inimigas = falso
					pare
				}
			}
		}
		
		// Se as condiçõe acima forem satisfeitas a jogada é realizada
		se(pecas_proprias == verdadeiro e pecas_inimigas == verdadeiro){
			para(inteiro j = posicao_j; j > auxiliar; j--){
				auxiliar2++
				se(flag){
					matriz_posicao[posicao_i][j] = 2
					grf.desenhar_imagem(j*75 + 32, posicao_i*75 + 31, imagem_ficha_branca)
					grf.renderizar()
				}
			}
			jogada_realizada_horizontal = verdadeiro
		}

		// Verificação horizontal a direita de onde clicou		
		
		pecas_proprias = falso
		pecas_inimigas = verdadeiro
		
		// Verifica se existe uma peça branca a direita de onde clicou
		para(inteiro j = posicao_j + 2; j <= 7; j++){
			se(matriz_posicao[posicao_i][j] == 2){	
				pecas_proprias = verdadeiro
				auxiliar = j
				pare
			}
		}
		
		// Verifica se as peças entre onde clicou e a preta a direita são todas brancas
		se(pecas_proprias == verdadeiro){
			para(inteiro j = posicao_j + 1; j < auxiliar ;j++){
				se(matriz_posicao[posicao_i][j] != 1){
					pecas_inimigas = falso
					pare
				}
			}
		}
		
		// Se as condiçõe acima forem satisfeitas a jogada é realizada
		se(pecas_proprias == verdadeiro e pecas_inimigas == verdadeiro){
			para(inteiro j = posicao_j; j < auxiliar; j++){
				auxiliar2++
				se(flag){
					matriz_posicao[posicao_i][j] = 2
					grf.desenhar_imagem(j*75 + 32, posicao_i*75 + 31, imagem_ficha_branca)
					grf.renderizar()
				}
			}
			jogada_realizada_horizontal = verdadeiro
		}
	}

	// Faz a verificação na diagonal principal da jogada e vira as peças possiveis
	funcao diagonal_principal_branco(logico flag)
	{
		// Verificação diagonal a esquerda de onde clicou		
		
		pecas_proprias = falso
		jogada_realizada_diagonal_principal = falso
		pecas_inimigas = verdadeiro

		// Verifica se existe uma peça preta na parte esquerda da diagonal principal de onde clicou
		para(inteiro k = 2; posicao_i - k >= 0 e posicao_j - k >= 0; k++){
			se(matriz_posicao[posicao_i-k][posicao_j-k] == 2){	
				pecas_proprias = verdadeiro
				auxiliar = k
				pare
			}
		}

		// Verifica se as peças entre onde clicou e a preta a esquerda são todas brancas
		se(pecas_proprias == verdadeiro){
			para(inteiro k = 1; k < auxiliar ; k++){
				se(matriz_posicao[posicao_i-k][posicao_j-k] != 1){
					pecas_inimigas = falso
					pare
				}	
			}
		}

		// Se as condiçõe acima forem satisfeitas a jogada é realizada
		se(pecas_proprias == verdadeiro e pecas_inimigas == verdadeiro){
			para(inteiro k = 0; k < auxiliar; k++){
				auxiliar2++
				se(flag){
					matriz_posicao[posicao_i-k][posicao_j-k] = 2
					grf.desenhar_imagem((posicao_j-k)*75 + 32, (posicao_i-k)*75 + 31, imagem_ficha_branca)
					grf.renderizar()
				}
			}
			jogada_realizada_diagonal_principal=verdadeiro
		}

		// Verificação diagonal a direita de onde clicou		
		
		pecas_proprias = falso
		pecas_inimigas = verdadeiro

		// Verifica se existe uma peça preta na parte direita da diagonal principal de onde clicou
		para(inteiro k = 2; posicao_i + k <= 7 e posicao_j + k <= 7; k++){
			se(matriz_posicao[posicao_i+k][posicao_j+k] == 2){	
				pecas_proprias = verdadeiro
				auxiliar = k
				pare
			}
		}

		// verifica se as peças entre onde clicou e a preta a esquerda são todas brancas
		se(pecas_proprias == verdadeiro){
			para(inteiro k = 1; k < auxiliar ; k++){
				se(matriz_posicao[posicao_i+k][posicao_j+k] != 1){
					pecas_inimigas = falso
					pare
				}	
			}
		}

		// se as condiçõe acima forem satisfeitas a jogada é realizada
		se(pecas_proprias == verdadeiro e pecas_inimigas == verdadeiro){
			para(inteiro k = 0; k < auxiliar; k++){
				auxiliar2++
				se(flag){
					matriz_posicao[posicao_i+k][posicao_j+k] = 2
					grf.desenhar_imagem((posicao_j+k)*75 + 32, (posicao_i+k)*75 + 31, imagem_ficha_branca)
					grf.renderizar()
				}
			}
			jogada_realizada_diagonal_principal=verdadeiro
		}
	}

	// Faz a verificação na diagonal secunaria da jogada e vira as peças possiveis
	funcao diagonal_secundaria_branco(logico flag){
		// Verificação diagonal a esquerda de onde clicou		
		
		pecas_proprias = falso
		jogada_realizada_diagonal_secundaria = falso
		pecas_inimigas = verdadeiro

		// Verifica se existe uma peça preta na parte esquerda da diagonal secundaria de onde clicou
		para(inteiro k = 2; posicao_i + k <= 7 e posicao_j - k >= 0; k++){
			se(matriz_posicao[posicao_i+k][posicao_j-k] == 2){	
				pecas_proprias = verdadeiro
				auxiliar = k
				pare
			}
		}

		// Verifica se as peças entre onde clicou e a preta a esquerda são todas brancas
		se(pecas_proprias == verdadeiro){
			para(inteiro k = 1; k < auxiliar ; k++){
				se(matriz_posicao[posicao_i+k][posicao_j-k] != 1){
					pecas_inimigas = falso
					pare
				}	
			}
		}

		// Se as condiçõe acima forem satisfeitas a jogada é realizada
		se(pecas_proprias == verdadeiro e pecas_inimigas == verdadeiro){
			para(inteiro k = 0; k < auxiliar; k++){
				auxiliar2++
				se(flag){
					matriz_posicao[posicao_i+k][posicao_j-k] = 2
					grf.desenhar_imagem((posicao_j-k)*75 + 32, (posicao_i+k)*75 + 31, imagem_ficha_branca)
					grf.renderizar()
				}
			}
			jogada_realizada_diagonal_secundaria=verdadeiro
		}

		// Verificação diagonal a direita de onde clicou		
		
		pecas_proprias = falso
		pecas_inimigas = verdadeiro

		// Verifica se existe uma peça preta na parte direita da diagonal secundaria de onde clicou
		para(inteiro k = 2; posicao_i - k >= 0 e posicao_j + k <= 7; k++){
			se(matriz_posicao[posicao_i-k][posicao_j+k] == 2){	
				pecas_proprias = verdadeiro
				auxiliar = k
				pare
			}
		}

		// Verifica se as peças entre onde clicou e a preta a direita são todas brancas
		se(pecas_proprias == verdadeiro){
			para(inteiro k = 1; k < auxiliar ;k++){
				se(matriz_posicao[posicao_i-k][posicao_j+k] != 1){
					pecas_inimigas = falso
					pare
				}	
			}
		}

		// Se as condiçõe acima forem satisfeitas a jogada é realizada
		se(pecas_proprias == verdadeiro e pecas_inimigas == verdadeiro){
			para(inteiro k = 0; k < auxiliar; k++){
				auxiliar2++
				se(flag){
					matriz_posicao[posicao_i-k][posicao_j+k] = 2
					grf.desenhar_imagem((posicao_j+k)*75 + 32, (posicao_i-k)*75 + 31, imagem_ficha_branca)
					grf.renderizar()
				}
			}
			jogada_realizada_diagonal_secundaria = verdadeiro
		}
	}

	// identifica a jogada que captura o maior numero de peças do oponente
	funcao melhor_jogada()
	{	
		pecas_roubadas = 0
		para(inteiro i = 0; i <= 7; i++){
			para(inteiro j = 0; j <= 7; j++){
				se(matriz_posicao[i][j] == 0){
					auxiliar2 = 0
					posicao_j = j
					posicao_i = i
					vertical_branco(falso)
					horizontal_branco(falso)
					diagonal_principal_branco(falso)
					diagonal_secundaria_branco(falso)
					se(auxiliar2 > pecas_roubadas){
						pecas_roubadas = auxiliar2
						melhor_jogada_i = i
						melhor_jogada_j = j
					}
				}
			}
		}
	}

	//
	// Essa parte trata de desenhar o tabuleiro e seus elementos 
	//

	// Desenha o tabuleiro
	funcao tabuleiro()
	{
		grf.desenhar_imagem(0, 0, imagem_tabuleiro)
		desenhar_peca_inicial()
	}

	// Função desenhar fichas iniciais que são apresentadas no começo do jogo
	funcao desenhar_peca_inicial()
	{
		grf.desenhar_imagem(332, 256, imagem_ficha_preta)
		grf.desenhar_imagem(257, 256, imagem_ficha_branca)
		grf.desenhar_imagem(257, 331, imagem_ficha_preta)
		grf.desenhar_imagem(332, 331, imagem_ficha_branca)
	}

	// Coloca as peças nas posições iniciais
	funcao posicao_inicial()
	{
		// Zera a matriz inicial
		zerar_matriz()
		
		// Valores das posições das peças iniciais que aparecem ao abrir o jogo
		matriz_posicao[3][3] = 2
		matriz_posicao[3][4] = 1
		matriz_posicao[4][3] = 1
		matriz_posicao[4][4] = 2
	}

	// Zera a matriz posição
	funcao zerar_matriz()
	{
		// Atribui valores a matriz da posição
		para(inteiro i = 0; i < 8; i++){
			para(inteiro j = 0; j < 8; j++){
				matriz_posicao[i][j] = 0
			}
		}
	}


	//
	// Essa parte trata de funções referentes a inicialização do modo gráfico e encerramento
	//

	// Função que inicia o modo gráfico para o menu
	funcao inicializar()
	{
		grf.iniciar_modo_grafico(falso)
		grf.definir_dimensoes_janela(LARGURA_MENU, ALTURA_MENU)
		grf.definir_titulo_janela("REVERSI: THE GAME")
	}

	// Funçõo que inicia o modo gráfico para o jogo
	funcao inicializar_jogo()
	{
		grf.iniciar_modo_grafico(falso)
		grf.definir_titulo_janela(TITULO)
		grf.definir_dimensoes_janela(LARGURA_JOGO, ALTURA_JOGO)
	}

	// Função que armazena imagens em variáveis
	funcao carregar_imagens()
	{
		cadeia pasta_imagens = "./IMAGENS/"
		imagem_fundo_menu = grf.carregar_imagem(pasta_imagens + "Lake.png")
		imagem_humano_IA = grf.carregar_imagem(pasta_imagens + "Humano_IA.png")
		imagem_creditos = grf.carregar_imagem(pasta_imagens + "Creditos.png")
		imagem_tabuleiro = grf.carregar_imagem(pasta_imagens + "Tabuleiro.png")
		imagem_ficha_branca = grf.carregar_imagem(pasta_imagens + "Ficha_branca.png")
		imagem_ficha_preta = grf.carregar_imagem(pasta_imagens + "Ficha_preta.png")
		imagem_ficha_preta1 = grf.carregar_imagem(pasta_imagens + "Ficha_preta1.png")
		imagem_ficha_branca1 = grf.carregar_imagem(pasta_imagens + "Ficha_branca1.png")
		imagem_texto_branco = grf.carregar_imagem(pasta_imagens + "Texto_brancas.png")
		imagem_texto_preto = grf.carregar_imagem(pasta_imagens + "Texto_pretas.png")
		imagem_texto_humano = grf.carregar_imagem(pasta_imagens + "Texto_humano.png")
		imagem_texto_IA = grf.carregar_imagem(pasta_imagens + "Texto_IA.png")
		imagem_saudacao = grf.carregar_imagem(pasta_imagens + "saudacao.png")
		imagem_x = grf.carregar_imagem(pasta_imagens + "x.png")
		imagem_pressEnter = grf.carregar_imagem(pasta_imagens + "pressEnter.png")
		imagem_0 = grf.carregar_imagem(pasta_imagens + "0.png")
		imagem_1 = grf.carregar_imagem(pasta_imagens + "1.png")
		imagem_2 = grf.carregar_imagem(pasta_imagens + "2.png")
		imagem_3 = grf.carregar_imagem(pasta_imagens + "3.png")
		imagem_4 = grf.carregar_imagem(pasta_imagens + "4.png")
		imagem_5 = grf.carregar_imagem(pasta_imagens + "5.png")
		imagem_6 = grf.carregar_imagem(pasta_imagens + "6.png")
		imagem_7 = grf.carregar_imagem(pasta_imagens + "7.png")
		imagem_8 = grf.carregar_imagem(pasta_imagens + "8.png")
		imagem_9 = grf.carregar_imagem(pasta_imagens + "9.png")
		imagem_pretas = grf.carregar_imagem(pasta_imagens + "pretas.png")
		imagem_brancas = grf.carregar_imagem(pasta_imagens + "brancas.png")
	}

	// Saudação amigavel ao sair do jogo
	funcao saudacao()
	{
		grf.definir_opacidade(255)
		grf.desenhar_imagem(0, 0, imagem_saudacao)
		grf.renderizar()
		utl.aguarde(1500)
		grf.fechar_janela()
	}

	// Função que finaliza o modo gráfico para abrir outra janela
	funcao finalizar()
	{
		grf.encerrar_modo_grafico()
	}
	funcao contagem(){
	//percorrer a matriz contando 0's e 1's
		para(inteiro i = 0 ; i<8 ; i++){
			para(inteiro j = 0 ; j<8 ; j++){
				//contador preto
				se(matriz_posicao[i][j]==1){
					contadorp++
				}
				//contador Branco
				senao se(matriz_posicao[i][j]==2){
					contadorb++
				}
			}
		}
	}
	//Função que utiliza a função anterior e exibe as peças
	funcao pecas(){
		
		contagem()
		//imagens brancas
		grf.desenhar_imagem(350, 660, imagem_brancas)
		grf.definir_cor(grf.COR_PRETO)
		grf.desenhar_retangulo(500,665, 80, 100,falso,verdadeiro)
		grf.definir_cor(grf.COR_BRANCO)
		grf.definir_tamanho_texto(40)
		grf.desenhar_texto(500,665, contadorb+"")
		//imagens pretas
		grf.desenhar_imagem(650, 660, imagem_pretas)
		grf.definir_cor(grf.COR_PRETO)
		grf.desenhar_retangulo(800,665, 80, 100,falso,verdadeiro)
		grf.definir_cor(grf.COR_BRANCO)
		grf.definir_tamanho_texto(40)
		grf.desenhar_texto(800,665, contadorp+"")
		grf.renderizar()
		//zerar os contadores a cada rodada
		contadorp = 0
		contadorb = 0
	}
}
/* $$$ Portugol Studio $$$ 
 * 
 * Esta seção do arquivo guarda informações do Portugol Studio.
 * Você pode apagá-la se estiver utilizando outro editor.
 * 
 * @POSICAO-CURSOR = 11; 
 * @DOBRAMENTO-CODIGO = [50, 112, 128, 280, 406, 416, 425, 500, 576, 649, 721, 801, 882, 961, 1039, 1067, 1074, 1083, 1096, 1112, 1120, 1161];
 * @PONTOS-DE-PARADA = ;
 * @SIMBOLOS-INSPECIONADOS = ;
 * @FILTRO-ARVORE-TIPOS-DE-DADO = inteiro, real, logico, cadeia, caracter, vazio;
 * @FILTRO-ARVORE-TIPOS-DE-SIMBOLO = variavel, vetor, matriz, funcao;
 */