# Script Pitch <!-- omit in toc -->

- [**Topics**](#topics)
  - [**Tarefa 1 \& 2**](#tarefa-1--2)
  - [**Tarefa 3**](#tarefa-3)
  - [**Tarefa 4,5 e 6**](#tarefa-45-e-6)
  - [**Tarefa 7 \& 8**](#tarefa-7--8)
  - [**Relevancia para o mundo real (OUTRAS SOLUÇOES)**](#relevancia-para-o-mundo-real-outras-soluçoes)
- [**Full Script**](#full-script)
  - [**Slide 1: Title Slide**](#slide-1-title-slide)
  - [**Slide 2: Project Overview**](#slide-2-project-overview)
  - [**Slide 3: Challenges and Solutions**](#slide-3-challenges-and-solutions)
  - [**Slide 4: Task 1 \& 2 - Smart Meters and Energy Consumption**](#slide-4-task-1--2---smart-meters-and-energy-consumption)
  - [**Slide 5: Task 3 - Mapping Districts**](#slide-5-task-3---mapping-districts)
  - [**Slide 6: Tasks 4, 5 \& 6 - Data Warehouse and Fact Tables**](#slide-6-tasks-4-5--6---data-warehouse-and-fact-tables)
  - [**Slide 7: Tasks 7 \& 8 - OLAP Cube and Analysis**](#slide-7-tasks-7--8---olap-cube-and-analysis)
  - [**Slide 8: Real-World Relevance and Conclusions**](#slide-8-real-world-relevance-and-conclusions)
  - [**Q\&A Preparation**](#qa-preparation)
    - [**Potential Questions and Answers**](#potential-questions-and-answers)
  - [**Final Tips for Delivery**](#final-tips-for-delivery)
- [**Q\&A Preparation**](#qa-preparation-1)
    - [**Potential Questions and Answers**](#potential-questions-and-answers-1)
  - [**Final Tips for Delivery**](#final-tips-for-delivery-1)


## **Topics**

- Quem somos?
  - Nome
  - Agradecer a oportunidade
- Apresentar projeto
  - Cadeira de DAI
  - Análise de duas bases de dados da E-REDES
    - Tarefa 1: Percentagem de smart meters média de consumo de energia por contrato para 2024/06
    - Tarefa 2: Estudar a correlation between the percentage of smart 
meters and energy consumption per contract
    - Tarefa 3: Mapear distritos entre os dois datasets
    - Tarefa 4: Criar o SQL schema para a datawarehouse
    - Tarefa 5: Popular as tabelas de dimensão
    - Tarefa 6: Popular as tabelas de factos
    - Tarefa 7: Criar um OLAP cube
    - Tarefa 8: Realizar análises recorrendo ao OLAP cube
- Desafios encontrados:
  - Encontrar uma sequencia de passos para produzir os resultados de forma coerente, lógica, eficiente e simples
- Apresentação das tarefas:
  - Tarefa 1 & 2: 
  - Tarefa 3
  - Tarefa 4,5 e 6
  - Tarefa 7 & 8
- Relevancia do projeto no mundo real
- Agradecimentos Finais

### **Tarefa 1 & 2**

Utilizamos o Pentaho Schema Workbench para criar uma transformação que calculasse a percentagem de smart meters (contadores inteligentes) e o consumo médio de energia por contrato por município. 
Esta tarefa envolveu: 
- Tratar dataset A:
  - Seleção de colunas úteis
  - Garantir correção e integridade dos dados utilizados
  - Mudar labels das colunas para evitar conflitos entre datasets
  - Ordenar colunas (necessário para efetuar group by)
  - Formula para calcular Numero de contratos Smart Meters e nao smart meters
  - Agrupar por municipio
  - Formula para calcular percentagem
- Tratar dataset B:
  - Seleção de colunas úteis
  - Garantir correção e integridade dos dados utilizados
  - Mudar labels das colunas
  - Ordenar colunas (necessário para efetuar group by)
  - Agrupar por municipio (e por data)
- Juntar os dois datasets:
  - Juntar por municipio (inner join)
  - Calcular consumo por contrato (dataset B tinhamos o consumo e do dataset A tinhamos o numero de contratos)
  - Seleção de colunas úteis
  - Exportar para ficheiro CSV

Utilizamos o DataCleaner para criar um Scatter plot.

Ao analisar o scatter plot, concluimos que não há correlação entre a percentagem de smart meters e o consumo de energia por contrato. Se houvesse uma correlação, veríamos um _padrão com uma inclinação no Scatter Plot_. (FIX THIS SENTENCE)

### **Tarefa 3**

The names of the districts are now exactly the same in both datasets but we still assumed that the names could be slightly different and that the problem may recur. 

- Tratar dataset A e B (mesmas passos para ambos):
  - Selecionar só a colunado do distrito
  - Mudar nome das colunas para evitar conflitos entre datasets
  - Garantir correção e integridade dos dados utilizados
  - Ordenar colunas (necessário para efetuar group by)
  - Garantir que não há duplicados
- Juntar os dois datasets:
  - Juntar por distrito (full join)
  - Calcular Jaro-Winkler distance entre os nomes dos distritos
    - Porquê que escolhemos este? Existia algum melhor
  - Filtrar os que têm distancia menor que 0.95
    - Porquê este trashold?
  - Selecionar só a colunado do distrito de cada dataset
  - Exportar para ficheiro CSV

### **Tarefa 4,5 e 6**

- Criar o SQL schema
  - Constelation schema
    - This comes from the point that both datasets have chronological differences and we aimed to gather as much data as possible and avoid filtering out rows without information about both energy consumption and smart meter at the same time and location, in the case of a single fact table.
  - Tabelas de dimensão time and location que tem componente numérica e categórica (exemplo: season_name e season_id)
  - Tabelas de factos que tem as chaves estrangeiras para as tabelas de dimensão
- Script para a time dimension
  - Populamos automaticamente para todos os meses de 2020 até 2030
  - This is not only a more pragmatic way than doing it the ETL tool but also ensures chronological integrity, since creating it from datasets could violate that if (in this case) a month was missing
- Transformation para location dimension
  - Seleção de colunas úteis do dataset B
    - Porque era o que incluía mais informações sobre os municípios e parish
  - Ordenar colunas (necessário para efetuar group by)
  - Garantir que não há duplicados
  - Garantir correção e integridade dos dados utilizados
    - The  fields  with  null  parish  code  due  to  GDPR    (or  other  irregularities) (como indicado na fonte - site da EREDES)  were filtered  and  sent  to  an  output  file  with  the  purpose  of  further  analysis  and transformation.
  - Passar parish codes para inteiros para poderem ser utilizados como chaves estrangeiras
    - Some parish codes (namely from the municipality of Barcelos) include letters. As this field was used to build a surrogate key, a java script was needed to build integer keys.
  - Inserir na base de dados (ou dar update se já existir)
- Popular Energy Consumption Fact Table
  - Seleção de colunas úteis do dataset B
  - Mudar nome das colunas 
  - Garantir correção e integridade dos dados utilizados
    - The  fields  with  null  parish  code  due  to  GDPR    (or  other  irregularities) (como indicado na fonte - site da EREDES)  were filtered  and  sent  to  an  output  file  with  the  purpose  of  further  analysis  and transformation.
  - Ordenar colunas (necessário para efetuar group by)
  - Agrupar por distrito, municipio e parish
  - Fazer o mapping com a tabela de dimensão das localizações para ficar só com o identificador (surrogate key)
  - Fazer o mapping com a tabela de dimensão do tempo para ficar só com o identificador (surrogate key)
  - Inserir na base de dados (ou dar update se já existir)
- Popular Smart Meters Fact Table
  - Seleção de colunas úteis do dataset A
  - Mudar nome das colunas
  - Garantir correção e integridade dos dados utilizados
    - The  fields  with  null  parish  code  due  to  GDPR    (or  other  irregularities) (como indicado na fonte - site da EREDES)  were filtered  and  sent  to  an  output  file  with  the  purpose  of  further  analysis  and transformation.
  - Formula para calcular Numero de contratos Smart Meters e nao smart meters
  - Ordenar colunas (necessário para efetuar group by)
  - Agrupar por distrito, municipio e parish
  - Fazer o mapping com a tabela de dimensão das localizações para ficar só com o identificador (surrogate key)
  - Fazer o mapping com a tabela de dimensão do tempo para ficar só com o identificador (surrogate key)
  - Inserir na base de dados (ou dar update se já existir)
    - Given this fact table would be used to build a cube, storing smart measures as 
percentage did not seem the most correct choice.
    - With cube aggregation functions this measure would be distorted (it is a non-additive measure) even using the mean or maximum for example, would not assess the reality and could lead to underestimation or overestimation of data from different locations.

### **Tarefa 7 & 8**

- Define the virtual cube
  - Pentaho only supports star schema based cubes. To outmaneuver this, virtual cubes appear as an option to build a cube based on a constellation schema, that aggregates the measures with common dimensions from the two cubes built based on both fact tables.
  - Energy Consumption Cube
    - Dimensions: Time, Location
    - Measures: Sum Energy Consumption
  - Smart Meters Cube
    - Dimensions: Time, Location
    - Measures: Sum Smart Meters and Sum Non Smart Meters
  - Virtual Cube
    - Dimensions: Time, Location
      - Fomos buscar ao cube do consumo de energia mas ia dar ao mesmo
    - Measures: Measures dos dois cubes
      - Sum Energy Consumption, Sum Smart Meters, Sum Non Smart Meters
    - Calculated Member: Percentage of Smart Meters
      - Formula: [Sum Smart Meters] / ([Sum Smart Meters] + [Sum Non Smart Meters])
- Realizar análises recorrendo ao OLAP cube
  - 3 perguntas - but only for years with complete data from January to December.
  - Pergunta A: Has the **consumption** and **the percentage of smart meters** increased or decreased from one year to the next?
    - **Energy Consumption** by Years across Districts - Table
    - **Energy Consumption** by Years across Districts - Multiple Bar Chart (não dava para tirar grande análise)
    - **Energy Consumption by** Years across Districts - Line Chart
    - Conclusão **energy consumption**: 
      - has increased over the years in districts of Castelo Branco, Évora, Faro, Lisboa, Porto and Setúbal. 
      - Has decreased in Coimbra.
      - Has remained roughly the same in the districts of Aveiro, Braga, Beja, Bragança, Guarda, Leiria, Portalegre, Santarém, Viana do Castelo, Vila Real and Viseu.
    - **Percentage of Smart Meters** by Years across Districts - Multiple Bar Chart
    - **Percentage of Smart Meters** by Years across Districts - Line Chart
    - Since the previous query was only for years that had energy consumption with complete data from January to December, we thought it would be appropriate to do the same for the percentage of smart meters (2022 and 2024 have incomplete data for smart meters). However, the only resulting year was 2023, which did not allow for analysis of the evolution from one year to another. Thus, here is a query to analyze the values for all years where there is information on Smart Meters (although not entirely accurate, it may be relevant for making more comprehensive analyses).
    - **Percentage of Smart Meters** by Years (all years) across Districts - Multiple Bar Chart
    - **Percentage of Smart Meters** by Years (all years) across Districts - Line Chart
    - **Percentage of Smart Meters** by Years (all years) across Districts - Table
    - Conclusão **percentage of smart meters**:
      - The percentage of smart meters increased for all districts over the years.
     [COMPLETAR COM RELEVANCIA PARA MUNDO REAL]

  - Pergunta B: What is the influence of the season on consumption?
    - Energy Consumption by Season across Districts - Multiple Bar Chart
    - Due to the significant differences in consumption values and in order to better analyze each district, we applied some filtering.
      - Lisboa e Porto
      - Mais do que 7000000000: Aveiro, Braga, Coimbra, Faro, Leiria, Santarém e Setubal
      - Menos do que 7000000000: Castelo Branco, Évora, Guarda, Portalegre, Viana do Castelo, Vila Real, Viseu, Beja, Bragança
    - Conclusão:
      - There is a clear influence of the season on energy consumption.
      - We verify that in portuguese southern regions of Algarve and Alentejo (Faro, Beja, Portalegre, Évora) have higher energy consumption in Summer.
      - Northern and Central districts (Lisboa appears as an exception) such as Vila Real, Viseu, Castelo Branco, Aveiro, Leiria Guarda, Viana do Castelo, Bragança, Braga and Porto, winters are more demanding.
      - Milder districts like Coimbra, Setúbal and Santarém present an even energy consumption over all year. 
      - We can suppose that these seasonal influences on energy consumption may stem from factors such as increased tourism or temperature changes that lead to greater use of air conditioning or heating or energy for other sources.
      [COMPLETAR COM RELEVANCIA PARA MUNDO REAL]

  - Pergunta C: Is the percentage of smart meters having an impact on electricity consumption?
    - Energy Consumption and Percentage of Smart Meters by Month across Districts - Line Chart
    - Since the percentage of smart meters is significantly lower than energy consumption, it is not perceptible in the chart. Therefore, we decided to proportionally reduce energy consumption in order to have a clearer analysis.
    - Energy Consumption and Percentage of Smart Meters by Month across Districts - Line Chart (proportionally reduced)
    - Conclusão: 
      - We can observe energy consumption has not being impacted by the percentage of smart meters (this is expected from the conclusions drawn in task 2).
     [COMPLETAR COM RELEVANCIA PARA MUNDO REAL]
     
### **Relevancia para o mundo real (OUTRAS SOLUÇOES)**

A análise de dados é uma ferramenta poderosa que pode ajudar as empresas a tomar decisões informadas e a otimizar os seus processos.

Este projeto demonstra como a análise de dados pode impulsionar a inovação no setor energético, alinhando-se com a missão da Hitachi Vantara de criar soluções inteligentes e sustentáveis através da IoT e da transformação digital.


## **Full Script**

### **Slide 1: Title Slide**
**Script**:  
"Good [morning/afternoon], esteemed members of the jury. My name is [Your Name], and today I am excited to present our project on **Data Analysis and Integration**, developed as part of the **DAI course**. We analyzed real-world datasets from E-REDES to uncover insights into energy consumption patterns and the impact of smart meters in Portugal. Thank you for this opportunity to share our work and demonstrate the merit of our project."

---

### **Slide 2: Project Overview**
**Script**:  
"Our project involved analyzing two datasets from E-REDES:  
1. **Dataset A**: Number of active energy contracts by meter type.  
2. **Dataset B**: Monthly energy consumption by municipality.  

We performed eight key tasks, including data transformation, correlation analysis, SQL schema creation, and OLAP cube development. These tasks allowed us to derive actionable insights for energy providers and policymakers. 

---

### **Slide 3: Challenges and Solutions**
**Script**:  
"During the project, we faced several challenges:  
1. **Data Integration**: The datasets had different structures and granularities. We addressed this by creating a **constellation schema**, which allowed us to integrate the data without losing information. This solution ensured that we could analyze both datasets comprehensively.  
2. **Data Quality**: Some fields had null values due to GDPR or other irregularities. We filtered these fields and ensured data integrity through rigorous validation, demonstrating our commitment to delivering accurate and reliable results.  
3. **OLAP Limitations**: Pentaho only supports star schemas, so we used **virtual cubes** to aggregate measures from multiple fact tables, enabling advanced multidimensional analysis. This innovative approach allowed us to overcome technical limitations and deliver a robust solution."

---

### **Slide 4: Task 1 & 2 - Smart Meters and Energy Consumption**
**Script**:  
"In **Task 1**, we calculated the percentage of smart meters and the average energy consumption per contract for June 2024. This involved:  
- Cleaning and transforming both datasets, including handling null parish and municipality codes due to GDPR.  
- Grouping data by municipality and calculating the percentage of smart meters and energy consumption per contract.  

In **Task 2**, we used **DataCleaner** to create a scatter plot to study the correlation between smart meter adoption and energy consumption.  

**Key Insight**: There is **no significant correlation** between the percentage of smart meters and energy consumption. If a correlation existed, we would see a clear pattern or slope in the scatter plot. This suggests that while smart meters improve data collection, they may not directly influence consumer behavior.

---

### **Slide 5: Task 3 - Mapping Districts**
**Script**:  
"In **Task 3**, we mapped districts between the two datasets, assuming that names could differ slightly (e.g., due to typos). We used the **Jaro-Winkler similarity measure** to detect duplicates and ensure accurate mapping.  

**Why Jaro-Winkler?** It’s effective for comparing short strings like district names, considering both character similarity and position.  
**Why a threshold of 0.95?** This balanced precision and flexibility, ensuring valid matches while avoiding false positives.  

**Key Insight**: This approach ensured accurate mapping, even if district names were not identical, and can be reused for future datasets.

---

### **Slide 6: Tasks 4, 5 & 6 - Data Warehouse and Fact Tables**
**Script**:  
"In **Task 4**, we created an SQL schema using a **constellation schema** to handle datasets with different granularities. This allowed us to avoid filtering out rows missing information on both energy consumption and smart meters.  

In **Task 5**, we populated the **time and location dimension tables**. For the time dimension, we automatically generated data for all months from 2020 to 2030, ensuring chronological integrity. This pragmatic approach avoided potential issues with missing months in the datasets.  

For the location dimension, we converted parish codes to integers to use them as surrogate keys. Some codes included letters (e.g., in Barcelos), so we used a **JavaScript script** to build integer keys, ensuring data consistency.  

In **Task 6**, we populated the **fact tables** for energy consumption and smart meters. This involved:  
- Cleaning and transforming the data.  
- Mapping data to dimension tables using surrogate keys.  
- Ensuring data integrity by filtering null values due to GDPR.  

**Key Insight**: The constellation schema and surrogate keys ensured a robust and scalable data warehouse, ready for advanced analysis.

---

### **Slide 7: Tasks 7 & 8 - OLAP Cube and Analysis**
**Script**:  
In Task 7, we defined a virtual OLAP cube to aggregate measures from both fact tables, enabling multidimensional analysis. Since Pentaho only supports star schemas, we used a virtual cube to combine the measures from the energy consumption and smart meters cubes.

To create the virtual cube, we first built a cube containing the energy consumption measure. Then, we created another cube with the sum of smart meters and non-smart meters. Finally, we constructed a virtual cube that aggregated the measures from both cubes. Additionally, we included a calculated member to determine the percentage of smart meters, as this value is not an additive measure.

In **Task 8**, we performed three key analyses:  

1. **Evolution of Energy Consumption and Smart Meter Adoption**:  
   - Energy consumption **increased** in districts like Lisboa and Porto but **decreased** in Coimbra.  
   - The percentage of smart meters **increased across all districts**, but this did not significantly impact energy consumption.

> Dizer que só havia dados completos de smart meters para 2023, o que não dava para fazer uma análise.
> Por isso, passamos a analizar todos os anos onde havia informação sobre smart meters 

> Conclusões: 
> - The energy consumption has increased over the years in districts of Castelo Branco, Évora, Faro, Lisboa, Porto and Setúbal. The energy consumption remained roughly the same in the districts of Aveiro, Braga, Beja, Bragança, Guarda, Leiria, Portalegre, Santarém, Viana do Castelo, Vila Real and Viseu. Has decreased in Coimbra.
> - The percentage of smart meters increased for all districts over the years.

2. **Seasonal Influence on Consumption**:  
   - Southern regions like Faro had higher consumption in **summer**, likely due to air conditioning and tourism.  
   - Northern regions like Porto had higher consumption in **winter**, likely due to heating needs.  

> Conclusion:
> - There is a clear influence of the season on energy consumption. 
> - We verify that in portuguese southern regions of Algarve and Alentejo (Faro, Beja, Portalegre, Évora) have higher energy consumption in > Summer.
> - Northern and Central districts (Lisboa appears as an exception) such as Vila Real, Viseu, Castelo Branco, Aveiro, Leiria Guarda, Viana do > Castelo, Bragança, Braga and Porto, winters are more demanding.
> - Milder districts like Coimbra, Setúbal and Santarém present an even energy consumption over all year.
> - We can suppose that these seasonal influences on energy consumption may stem from factors such as increased tourism or temperature changes that lead to greater use of air conditioning or heating or energy for other sources.


3. **Impact of Smart Meters on Consumption**:  
   - There is **no significant impact** of smart meters on energy consumption, aligning with the findings from Task 2.  

**Key Insight**: These analyses provided actionable insights for energy providers and policymakers, demonstrating the **real-world value** of our work."

### **Slide 8: Real-World Relevance and Conclusions**  
**Script**:  
"Our findings offer insights that could inspire **examples of strategies** for energy providers and policymakers to consider, depending on their goals and contexts.

In conclusion, our project highlights the potential of data analysis to address challenges in the energy sector. Key takeaways include:  
- **Seasonal trends** play a significant role in energy consumption, and understanding these patterns could inform strategies for optimizing energy distribution.  
- **Smart meters** are widely adopted but may have untapped potential, suggesting opportunities for further exploration in consumer education and system integration.  
- **Data integration and advanced analytics** could serve as foundational tools for driving innovation and promoting sustainability in the energy sector.  

We believe this work aligns closely with Hitachi Vantara’s mission of driving innovation through data, and we are honored to present it for the Hitachi Prize. 

Thank you for your attention, and we look forward to your questions."

---

### **Q&A Preparation**

#### **Potential Questions and Answers**

1. **How does your project align with Hitachi Vantara’s focus on IoT and smart solutions?**  
   - **Answer**: "Our project aligns with Hitachi Vantara’s mission by leveraging data to drive innovation in the energy sector. By analyzing smart meter adoption and energy consumption, we’re providing actionable insights that can help optimize energy distribution and promote smarter energy management. This directly supports Hitachi’s focus on IoT and smart solutions, particularly in the context of smart grids and energy efficiency."

2. **What are the limitations of your analysis, and how would you address them in the future?**  
   - **Answer**: "One limitation is that our analysis is based on historical data, which may not fully capture future trends. In the future, we plan to incorporate predictive modeling using machine learning to forecast energy consumption patterns. Additionally, we aim to include external factors like weather data to refine our analysis further."

3. **How scalable is your solution for larger datasets or different regions?**  
   - **Answer**: "Our solution is highly scalable. We used distributed computing frameworks like Pentaho, which can handle large datasets efficiently. Additionally, our modular transformation pipelines can be easily adapted for different regions or datasets. For example, the constellation schema we developed can accommodate additional dimensions or measures, making it flexible for future use."

4. **What was the most challenging part of the project, and how did you overcome it?**  
   - **Answer**: "The most challenging part was integrating datasets with different structures and granularities. We overcame this by creating a constellation schema, which allowed us to maintain data integrity and avoid data loss. This approach ensured that we could perform accurate and comprehensive analysis across both datasets."

5. **How can your findings be applied in the real world?**  
   - **Answer**: "Our findings can help energy providers optimize their distribution networks and promote the adoption of smart meters. Policymakers can use these insights to design incentives for energy efficiency and sustainability. For example, regions with low smart meter adoption could be targeted for awareness campaigns or subsidies to encourage adoption."

---

### **Final Tips for Delivery**
- **Practice**: Rehearse your pitch multiple times to ensure smooth delivery and confident responses to questions.
- **Engage the Audience**: Make eye contact and use gestures to engage the jury. Show enthusiasm for your project.
- **Stay Calm and Confident**: Even if you don’t know the answer to a question, stay calm and provide a thoughtful response.

## **Q&A Preparation**

#### **Potential Questions and Answers**

1. **How does your project align with Hitachi Vantara’s focus on IoT and smart solutions?**  
   - **Answer**: "Our project aligns with Hitachi Vantara’s mission by leveraging data to drive innovation in the energy sector. By analyzing smart meter adoption and energy consumption, we’re providing actionable insights that can help optimize energy distribution and promote smarter energy management. This directly supports Hitachi’s focus on IoT and smart solutions, particularly in the context of smart grids and energy efficiency."

2. **What are the limitations of your analysis, and how would you address them in the future?**  
   - **Answer**: "One limitation is that our analysis is based on historical data, which may not fully capture future trends. In the future, we plan to incorporate predictive modeling using machine learning to forecast energy consumption patterns. Additionally, we aim to include external factors like weather data to refine our analysis further."

3. **How scalable is your solution for larger datasets or different regions?**  
   - **Answer**: "Our solution is highly scalable. We used distributed computing frameworks like Pentaho, which can handle large datasets efficiently. Additionally, our modular transformation pipelines can be easily adapted for different regions or datasets. For example, the constellation schema we developed can accommodate additional dimensions or measures, making it flexible for future use."

4. **What was the most challenging part of the project, and how did you overcome it?**  
   - **Answer**: "The most challenging part was integrating datasets with different structures and granularities. We overcame this by creating a constellation schema, which allowed us to maintain data integrity and avoid data loss. This approach ensured that we could perform accurate and comprehensive analysis across both datasets."

5. **How can your findings be applied in the real world?**  
   - **Answer**: "Our findings can help energy providers optimize their distribution networks and promote the adoption of smart meters. Policymakers can use these insights to design incentives for energy efficiency and sustainability. For example, regions with low smart meter adoption could be targeted for awareness campaigns or subsidies to encourage adoption."

---

### **Final Tips for Delivery**
- **Practice**: Rehearse your pitch multiple times to ensure smooth delivery and confident responses to questions.
- **Engage the Audience**: Make eye contact and use gestures to engage the jury. Show enthusiasm for your project.
- **Stay Calm and Confident**: Even if you don’t know the answer to a question, stay calm and provide a thoughtful response.

---

This script is designed to be **clear, concise, and impactful**, while demonstrating the **technical depth** and **real-world relevance** of your project. Let me know if you’d like further refinements! Good luck! 🚀