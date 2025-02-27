# New Version of the Pitch Script

### Slide 1: Apresentação

Bom dia, estimados membros do juri.O meu nome é [Nome] e o meu nome é [Outro Nome] e hoje vimos apresentar-vos o nosso projeto realizado no ambito da cadeira de Análise e Integração de Dados.  
Queremos desde já parabenizar os restantes grupos pelo seu desempenho, agradecer a oportunidade de mostrar o nosso trabalho e o reconhecimento do nosso esforço e dedicação.  

### Slide 2: Project Overview - Objetivo do Projeto

Este projeto tinha como objetivo analisar padrões no consumo de energia e na adoção de medidores inteligentes em Portugal. 
Para tal, recorremos a informações derivadas de dois datasets fornecidos pela E-REDES:
1. A partir do primeiro conseguimos obter informações relativas ao número de contratos de energia por tipo de medidor.
2. Enquanto que no segundo obtemos os valores de consumo de energia mensal por município.

### Slide 3: Tasks e Tecnologias Utilizadas

Para alcançar o objetivo do projeto foi necessário integrar e analisar os dados desdes datasets e, para isso, utilizamos:

- Pentaho Data Integration para:
  - Criar transformações
  - Realizar o mapping entre regiões
  - Popular a nossa base de dados - onde primeiramente criamos um schema
- Pentaho Schema Workbench para:
  - Desenvolver o nosso OLAP cube
- DataCleaner para:
  - Limpar e preparar os dados
  - Analisar a correlação entre as variáveis
- Pentaho Server e Saiku Analytics para:
  - Analisar os dados

### Slide 4: Challenges and Solutions

> Não gosto muito da frase 'nos tempos de recolha dos dados.'

Durante o desenvolvimento do projeto, deparamo-nos com alguns desafios, nomeadamente:
1. Para começar, os datasets utilizados não partilhavam a mesma cronologia. De forma a integrarmos o máximo de informação possível, e evitando linhas sem informação, optamos por criar um esquema em constelação com duas tabelas de factos.
2. Outro desafio foi lidar com irregularidades na informação e com os valores nulos provenientes dos datasets devido às politica de RGPD. Para resolver este problema, foi necessária a sua validação e filtragem.
3. Por fim, a criação do OLAP cube foi um desafio, uma vez que o Pentaho apenas suporta esquemas em estrela. Assim, utilizamos um virtual cube para agregar medidas das duas tabelas de fatos, permitindo análises multidimensionais avançadas.

### Slide 5: Task 1

Passamos agora a descrever brevemente as tarefas realizadas no âmbito do projeto.

A primeira tarefa consistia em calcular a percentagem da adoção de smart meters e o consumo médio de energia por contrato para Junho de 2024. Para tal, criamos uma transformação que limpa e trata os dados, removendo os valores das regiões nulas, e agrupandos os municípios, obtendo assim uma tabela final com os valores da percentagem de adoção de smart meters e do consumo médio de energia por contrato.

### Slide 6: Task 2

De seguida, analisámos a existência de correlação entre as métricas de interesse recorrendo a um gráfico de pontos, observando que existe não existe correlação. Tal permite inferir que adoção de contadores inteligentes não influencia diretamente o consumo de energia.

### Slide 7: Task 3

A terceira tarefa consistia em mapear os distritos entre os dois datasets. 

Com a atualização dos dados pela E-Redes, os nomes dos distritos apresentavam configuração idêntica. Ainda assim, assumiu-se a existência de ligeiras diferenças.

Utilizando a transformação apresentada no slide, e a métrica de similaridade de Jaro-Winkler com um treshold de 0.95, esta tarefa foi realizada com sucesso.

Esta métrica foi escolhida uma vez que é ideal para comparar pequenas strings, como o caso dos nomes dos distritos, considerando a similaridade e posição de cada caracter.


### Slide 8: Task 4

Passando para a criação do datawarehouse com fim à análise dos dados, optámos por criar um constellation schema, tendo as tabelas de localização e de tempo como tabelas de dimensão e as tabelas de consumo de energia e de adoção de smart meters como tabelas de factos.

### Slide 9: Task 5

Começando por popular as tabelas de dimensão, a tabela do tempo foi preenchida diretamente através dum script sql com as datas desde 2020 a 2030, procurando garantir a integridade cronológica da nossa base de dados, evitando potenciais problemas com meses em falta nos datasets. Além disso extraiu-se a componente sazonal, introduzindo outro nível de granularidade ao tempo com a inclusão das estação do ano a que cada mês pertence.

Por outro lado, a tabela das localizações foi preenchida com uma transformação no PDI. Destaco que um dos desafios desta transformação foi a criação de um script de Javascript que nos permitisse converter as strings com o código das freguesias para números inteiros, de forma a poderem ser utilizadas eficientemente como surrogate keys.

### Slide 10: Task 6

Relativamente às tabelas de factos criamos duas transformações que envolviam:
- Transformação das informações, calculando as métricas necessárias e removendo os valores nulos ou incorretos.
- Mapeamento das localizações e tempo para as surrogate keys

### Slide 11: Task 7

Na Tarefa 7, definimos um virtual OLAP cube para agregar as medidas de ambas as tabelas de fatos, permitindo a análise multidimensional.

Assim, foi necessário criar um cubo com as medidas de consumo de energia, outro com os números de contratos com e sem smart meters, e agregá-los  no cubo final. Às métricas anteriormente mencionadas acresentou-se um calculated member correspondente com a percentagem de adoção de smart meters uma vez que estamos a lidar com uma medida não aditiva.

### Slide 12: Task 8

Finalmente, a análise dos dados com manipulando o cubo criado e utilizando o Saiku Analytics para a produção dos gráficos mais informativos, permitiu a resposta às seguintes questões:
1. Terá o consumo de energia aumentado de um ano para o outro?
    - Com este gráfico de linhas conseguimos concluir que aumentou em algumas regiões como Faro e Lisboa, mas que diminiu em outras como em Coimbra.
2. Terá a percetagem de adoção de smart meters aumentado?
    - Com este gráfico de linhas observa-se a crescente adoção de contadores inteligentes em todas as regiões portuguesas.
3. Qual é a influencia da estação do ano no consumo de energia?
   - Os gráficos de barras criados revelam que em regiões mais a Sul como Faro tem maior consumo no verão enquanto que em regiões mais a Norte, como Porto,tal se sucede no inverno.
4. A percentagem de adoção de smart meters influencia o consumo de energia?
    - Com este gráfico, tal como previsto após a realização da tarefa 2, verifica-se que não existe evidência de uma correlação entre a adoção de smart meters e o consumo de energia.

### Slide 16: Relevância no Mundo real

Todas estas análises permitem ajudar a enfrentar desafios do setor do consumo de energia uma vez que nos ajudam a:
- Perceber os padrões de consumo durante as estações do ano, permitindo uma melhor gestão da distribuição de energia.
- Compreender que a adoção de contadores inteligentes não tem influenciado diretamente o consumo de energia, o que cria oportunidades para na exploração da educação do consumidor.
- A continuação destas análises poderá servir para impulsionar a inovação e promover a sustentabilidade no setor energético.

Por fim gostariamos de terminar, destacando que as nossas soluções garantem uma integração robusta dos dados e análises criteriosas, permitindo escalabilidade e superando desafios técnicos e estruturais, buscando rigor, simplicidade e a preservação da integridade dos dados.

### Slide 17: Obrigado

Muito obrigada pela vossa atenção e agora estaremos disponíveis para responder às vossas questões.


INFO EXTRA
_________________________________________________________________________
Vantagens dos contadores inteligentes

Regista o seu consumo de eletricidade a cada momento e comunica-o de forma automática, sem necessidade de intervenção manual. *
Elimina as faturas por estimativa e providencia consumos exatos.
Rastreia facilmente o que o cliente utiliza e gasta. O visor mostra-lhe quanta energia está a utilizar em tempo real.
Encoraja melhores hábitos energéticos. A visualização da energia usada estimula a sua redução.
Ajuda a reduzir a sua pegada de carbono. O cliente pode adotar comportamentos de poupança de energia, reduzindo as emissões de CO2 em sua casa