# New Version of the Pitch Script

> ### Slide 1: Apresentação - Ana
> 
> Bom dia, estimados membros do juri.  
> O meu nome é Ana e este é o meu colega Vasco e hoje vimos apresentar-vos o nosso projeto realizado no ambito da cadeira de Análise e Integração de Dados.  
> Queremos desde já expressar a nossa gratidão pelo reconhecimento do nosso esforço e dedicação, agradecer a oportunidade de mostrar o nosso trabalho e  dar os parabens aos restantes grupos pelo seu desempenho.

### Slide 2: Project Overview - Objetivo do Projeto - Vasco

Este projeto tinha como objetivo analisar padrões no consumo de energia e na adoção de medidores inteligentes em Portugal. 
Para tal, recorremos a informações derivadas de dois datasets fornecidos pela E-REDES:
1. A partir do primeiro conseguimos obter informações relativas ao número de contratos de energia por tipo de medidor.
2. Enquanto que no segundo obtemos os valores de consumo de energia mensal por município.

### Slide 3: Tasks e Tecnologias Utilizadas - Vasco

Para alcançar o objetivo do projeto foi necessário integrar e analisar os dados desdes datasets e, para isso, utilizamos:

- Pentaho Data Integration para:
  - Criar transformações procurando uma sequência eficiente de passos, que minimizam os acessos à base de dados, e optimizam o uso de recursos e o tempo de processamento.
  - Realizar o mapping entre regiões
  - Popular a nossa base de dados - onde primeiramente criamos um schema em SQL
- Pentaho Schema Workbench para:
  - Desenvolver o nosso OLAP cube
- DataCleaner para:
  - Limpar e preparar os dados
  - Analisar a correlação entre as variáveis
- Pentaho Server e Saiku Analytics para:
  -  Analisar os dados recorrendo a gráficos obtidos com MDX queries

> ### Slide 4: Challenges and Solutions - Ana
> 
> Durante o desenvolvimento do projeto, deparamo-nos com alguns desafios.
> 1. Começando pelo facto dos datasets utilizados não partilharem a mesma cronologia foi necessária arranjar forma de integrarmos o máximo de informação possível, e evitar linhas sem informação. Acabamos por optar por criar um esquema em constelação com duas tabelas de factos.
> 2. Outro desafio foi lidar com irregularidades na informação e com os valores nulos provenientes dos datasets devido às politica de RGPD. Para resolver este problema, foi necessária a validação e filtragem dos dados.
> 3. Por fim, a criação do OLAP cube foi um desafio. Uma vez que o Pentaho apenas suporta esquemas em estrela foi necessário utilizamos um virtual cube para agregar as medidas das duas tabelas de fatos, permitindo análises multidimensionais avançadas.

### Slide 5: Task 1 - Vasco

Passamos agora a descrever brevemente as tarefas realizadas no âmbito do projeto.

A primeira tarefa consistia em calcular a percentagem da adoção de smart meters e o consumo médio de energia por contrato para Junho de 2024. Para tal, criamos uma transformação que limpa e trata os dados, removendo os valores das regiões nulas, e agrupandos os municípios, obtendo assim uma tabela final com os valores da percentagem de adoção de smart meters e do consumo médio de energia por contrato.

### Slide 6: Task 2 - Vasco

De seguida, analisámos a existência de correlação entre as métricas de interesse recorrendo a um gráfico de pontos, observando que existe não existe correlação. Tal permite inferir que adoção de contadores inteligentes não influencia diretamente o consumo de energia.

> ### Slide 7: Task 3 - Ana
> 
> A terceira tarefa consistia em mapear os distritos entre os dois datasets. 
> 
> Com a atualização dos dados pela E-Redes, os nomes dos distritos apresentavam configuração idêntica. Ainda assim, assumiu-se a existência de ligeiras diferenças e então utilizamos a transformação apresentada no slide, e a métrica de similaridade de Jaro-Winkler com um treshold de 0.95.
> 
> Esta métrica foi escolhida uma vez que é ideal para comparar pequenas strings, como é o caso dos nomes dos distritos, uma vez que considera a similaridade e posição de cada caracter.

### Slide 8: Task 4 - Vasco

Passando para a criação do datawarehouse com fim à análise dos dados, optámos por criar um constellation schema, tendo as tabelas de localização e de tempo como tabelas de dimensão e as tabelas de consumo de energia e de adoção de smart meters como tabelas de factos.

### Slide 9: Task 5 - Vasco

Começando por popular as tabelas de dimensão, a tabela do tempo foi preenchida diretamente através dum script sql com as datas desde 2020 a 2030, procurando garantir a integridade cronológica da nossa base de dados, evitando potenciais problemas com meses em falta nos datasets. Além disso extraiu-se a componente sazonal, introduzindo outro nível de granularidade ao tempo com a inclusão das estação do ano a que cada mês pertence.

Por outro lado, a tabela das localizações foi preenchida com uma transformação no PDI. Destaco que um dos desafios desta transformação foi a criação de um script de Javascript que nos permitisse converter as strings com o código das freguesias para números inteiros, de forma a poderem ser utilizadas eficientemente como surrogate keys.

### Slide 10: Task 6 - Vasco

Relativamente às tabelas de factos criamos duas transformações que envolviam:
- Transformação das informações, calculando as métricas necessárias e removendo os valores nulos ou incorretos.
- Mapeamento das localizações e tempo para as surrogate keys

> ### Slide 11: Task 7 - Ana 
> 
> Na Tarefa 7, definimos um virtual OLAP cube para agregar as medidas de ambas as tabelas de fatos, permitindo assim a análise multidimensional.
> 
> Para tal foi necessário criar um cubo com as medidas de consumo de energia, outro com os números de contratos com e sem smart meters, e agregá-los no cubo final. 
> Às métricas anteriormente mencionadas acresentou-se um calculated member correspondente à percentagem de adoção de smart meters uma vez que estamos a lidar com uma medida não aditiva.
> 
> ### Slide 12: Task 8 - Ana
> 
> Finalmente, manipulando o cubo criado e utilizando o Saiku Analytics executamos MDX queries que nos permitiram a produção dos gráficos mais informativos para responder às questões que eram colocadas:
> 1. A primeira questão era se o consumo de energia teria aumentado ou diminuido de um ano para o outro?
>   - Entre diferentes tipos de gráficos optamos por este gráfico de linhas que nos permite analisar o consumo de energia para cada distrito, em 3 anos diferentes.
>   - Ao observa-lo concluimos que o consumo de energia aumentou em algumas regiões como Faro e Lisboa, mas que diminiu em outras como em Coimbra.
> 2. A pergunta seguinte, semelhante à anterior, questionava se a percetagem de adoção de smart meters aumentado ou diminuido ao longo dos anos?
>   - Com este gráfico de linhas observa-se a crescente adoção de contadores inteligentes em todas as regiões portuguesas.
> 3. A terceira pergunta era qual seria a a influencia da estação do ano no consumo de energia?
>   - De forma a analisar melhor as informações decidimos utilizar gráficos de barras, mas como o consumo de energia varia muito entre regiões, acabamos por executar 3 MDX queries diferentes que nos permitiram ajustar a escala dos gráficos para melhor visualização.
>   - Os gráficos de barras criados revelam que em regiões mais a Sul como Faro tem maior consumo no verão enquanto as regiões mais a Norte, como no Porto, tal se sucede no inverno.
>   - Podemos colocar a hipotese de que este facto se deve ao aumento do turismo em certas regiões ou à diferenças de temperatura ao longo do ano que acabam por levar a um maior uso de ar condicionado na zona Sul e de aquecedores na zona Norte.
> 4. Por fim, a última pergunta era se a percentagem de adoção de smart meters influencia o consumo de energia?
>   - Tal como já tinha sido analisado na tarefa 2, acabamos por concluir que não existe correlação entre a adoção de smart meters e o consumo de energia.
>   - Conseguimos chegar a essa conclusão através deste gráfico de linhas que proporcionalmente aumenta a percentagem de adoção de smart meters de forma a ser possivel visualizar que este valor se mantem sempre crescente ao longo do ano para todas as regiões enquanto que o consumo de energia varia de forma irregular. 

### Slide 16: Relevância no Mundo Real - Vasco
Todas estas análises permitem ajudar a enfrentar desafios do setor do consumo de energia uma vez que nos ajudam a:

- Perceber os padrões de consumo durante as estações do ano, permitindo uma melhor gestão da distribuição de energia.

- Compreender que a adoção de contadores inteligentes não tem influenciado diretamente o consumo de energia, o que cria oportunidades para a exploração da educação do consumidor.

Os contadores inteligentes registam o consumo de eletricidade em tempo real, eliminando faturas por estimativa e fornecendo dados exatos.

Eles permitem que os clientes rastreiem facilmente o que utilizam e gastam, mostrando o consumo de energia em tempo real, o que pode encorajar melhores hábitos energéticos.

A visualização do consumo em tempo real pode estimular a redução do uso de energia, ajudando a reduzir a pegada de carbono e promovendo comportamentos de poupança de energia.

A continuação destas análises poderá servir para impulsionar a inovação e promover a sustentabilidade no setor energético, ao integrar dados robustos e análises criteriosas que permitem escalabilidade e superação de desafios técnicos e estruturais.

Por fim, gostaríamos de terminar destacando que as nossas soluções garantem uma integração robusta dos dados e análises criteriosas, permitindo escalabilidade e superando desafios técnicos e estruturais, buscando rigor, simplicidade e a preservação da integridade dos dados.

### Slide 17: Obrigado - Vasco

Muito obrigado pela vossa atenção e agora estaremos disponíveis para responder às vossas questões.
