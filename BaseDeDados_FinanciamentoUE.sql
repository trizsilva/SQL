-- 

USE FinanciamentosUE;
GO

-- 1. Tabela ESTADO_MEMBRO
CREATE TABLE estado_membro (
    id INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    sigla VARCHAR(2) NOT NULL,
    moeda VARCHAR(50) NOT NULL
);


-- 2. Tabela AREA_FINANCIAMENTO
CREATE TABLE area_financiamento (
    id INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(300)
);

-- 3. Tabela TIPO_FINANCIAMENTO
CREATE TABLE tipo_financiamento (
    id INT PRIMARY KEY,
    descricao VARCHAR(100) NOT NULL
);

-- 4. Tabela ENTIDADE_GESTORA
CREATE TABLE entidade_gestora (
    id INT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    website VARCHAR(200),
    email VARCHAR(150)
);

-- 5. Tabela BENEFICIARIO
CREATE TABLE beneficiario (
    id INT PRIMARY KEY,
    nome VARCHAR(200) NOT NULL,
    rua VARCHAR(150) NOT NULL,
    codigo_postal VARCHAR(10) NOT NULL, 
    localidade VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL,
    nif VARCHAR(9) NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    id_estado_membro INT NOT NULL,
    CONSTRAINT fk_beneficiario_estado FOREIGN KEY (id_estado_membro) REFERENCES estado_membro(id)
);

-- 6. Tabela PROGRAMA
CREATE TABLE programa (
    id INT PRIMARY KEY,
    nome VARCHAR(200) NOT NULL,
    descricao VARCHAR(500),
    estado VARCHAR(50) NOT NULL,
    data_abertura DATE NOT NULL,
    data_fecho DATE NOT NULL,
    orcamento_total DECIMAL(14,2) NOT NULL,
    id_area INT NOT NULL,
    id_tipo_financiamento INT NOT NULL,
    id_entidade_gestora INT NOT NULL,
    CONSTRAINT fk_programa_area FOREIGN KEY (id_area) REFERENCES area_financiamento(id),
    CONSTRAINT fk_programa_tipo FOREIGN KEY (id_tipo_financiamento) REFERENCES tipo_financiamento(id),
    CONSTRAINT fk_programa_gestora FOREIGN KEY (id_entidade_gestora) REFERENCES entidade_gestora(id)
);

-- Restrição CHECK para garantir que a data de fecho é sempre posterior à data de abertura do programa.
ALTER TABLE programa
ADD CONSTRAINT chk_datas_programa
CHECK (data_fecho > data_abertura);

-- 7. Tabela CANDIDATURA
CREATE TABLE candidatura (
    id INT PRIMARY KEY,
    id_programa INT NOT NULL,
    id_beneficiario INT NOT NULL,
    data_submissao DATE NOT NULL,
    estado VARCHAR(50) NOT NULL,
    valor_pedido DECIMAL(12,2) NOT NULL,
    valor_aprovado DECIMAL(12,2),
    data_decisao DATE,
    CONSTRAINT fk_candidatura_programa FOREIGN KEY (id_programa) REFERENCES programa(id),
    CONSTRAINT fk_candidatura_beneficiario FOREIGN KEY (id_beneficiario) REFERENCES beneficiario(id)
);


-- 8. Tabela BENEFICIARIO_TELEFONE
-- (Implementa o atributo multivalor "telefone" do beneficiário, permitindo que um beneficiário tenha um ou mais contactos telefónicos.)
CREATE TABLE beneficiario_telefone (
    id_beneficiario INT NOT NULL,
    telefone VARCHAR(15) NOT NULL,
    PRIMARY KEY (id_beneficiario, telefone),
    CONSTRAINT fk_beneficiario_telefone
        FOREIGN KEY (id_beneficiario)
        REFERENCES beneficiario(id)
);

-- 1. Inserir Estados-Membros
INSERT INTO estado_membro (id, nome, sigla, moeda) VALUES
(1, 'Portugal', 'PT', 'Euro'),
(2, 'Espanha', 'ES','Euro'),
(3, 'França', 'FR', 'Euro'),
(4, 'Alemanha', 'DE', 'Euro'),
(5, 'Itália', 'IT', 'Euro');

-- 2. Inserir Áreas de Financiamento
INSERT INTO area_financiamento (id, nome, descricao) VALUES
(1, 'Investigação', 'Projetos científicos e tecnológicos'),
(2, 'Educação', 'Programas de ensino e formação'),
(3, 'Digitalização', 'Transformação digital'),
(4, 'Ambiente', 'Sustentabilidade ambiental'),
(5, 'Desenvolvimento Regional', 'Crescimento económico regional');

-- 3. Inserir Tipos de Financiamento
INSERT INTO tipo_financiamento (id, descricao) VALUES
(1, 'Subvenção'),
(2, 'Empréstimo'),
(3, 'Garantia'),
(4, 'Prémio');

-- 4. Inserir Entidades Gestoras
INSERT INTO entidade_gestora (id, nome, website, email) VALUES
(1, 'Comissão Europeia', 'https://commission.europa.eu', 'info@ec.europa.eu'),
(2, 'Portugal 2030', 'https://portugal2030.pt', 'geral@portugal2030.pt'),
(3, 'Agência Nacional de Inovação', 'https://ani.pt', 'geral@ani.pt'),
(4, 'IAPMEI', 'https://iapmei.pt', 'geral@iapmei.pt'),
(5, 'EACEA', 'https://www.eacea.ec.europa.eu', 'info@eacea.europa.eu');

-- 5. Inserir Beneficiários
INSERT INTO beneficiario (id, nome, rua, codigo_postal, localidade, email, telefone, nif, tipo, id_estado_membro) VALUES
(1, 'Universidade do Porto', 'Praça Gomes Teixeira', '4099-002', 'Porto', 'up@up.pt', '225000000', '501413197', 'Universidade', 1),
(2, 'TechStart Lda.', 'Rua da Indústria 10', '4700-010', 'Braga', 'geral@techstart.pt', '253111111', '509123456', 'Empresa', 1),
(3, 'Universidade Complutense', 'Ciudad Universitaria', '28040', 'Madrid', 'info@ucm.es', '910000000', 'A12345678', 'Universidade', 2),
(4, 'Ville de Paris', 'Hôtel de Ville', '75004', 'Paris', 'contact@paris.fr', '140000000', 'FR123456', 'Município', 3),
(5, 'Green Future Association', 'Alexanderplatz 1', '10178', 'Berlim', 'info@greenfuture.de', '301234567', 'DE987654', 'Associação', 4);

-- 6. Inserir Programas
INSERT INTO programa (id, nome, descricao, estado, data_abertura, data_fecho, orcamento_total, id_area, id_tipo_financiamento, id_entidade_gestora) VALUES
(1, 'Horizonte Europa', 'Investigação científica', 'Aberto', '2026-01-01', '2026-12-31', 95000000, 1, 1, 1),
(2, 'Erasmus+', 'Mobilidade académica', 'Aberto', '2026-02-15', '2026-09-30', 35000000, 2, 1, 5),
(3, 'Europa Digital', 'Transformação digital', 'Aberto', '2026-03-01', '2026-10-31', 42000000, 3, 1, 1),
(4, 'LIFE', 'Projetos ambientais', 'Fechado', '2026-01-01', '2026-06-30', 18000000, 4, 1, 1),
(5, 'Portugal 2030 PME', 'Competitividade empresarial', 'Aberto', '2026-04-01', '2026-12-31', 70000000, 5, 2, 2);

-- 7. Inserir Candidaturas
INSERT INTO candidatura (id, id_programa, id_beneficiario, data_submissao, estado, valor_pedido, valor_aprovado, data_decisao) VALUES
(1, 1, 1, '2026-01-10', 'Aprovada', 450000.00, 420000.00, '2026-03-15'),
(2, 1, 2, '2026-01-18', 'Em Avaliação', 300000.00, NULL, NULL),
(3, 2, 3, '2026-03-05', 'Aprovada', 120000.00, 120000.00, '2026-05-01'),
(4, 3, 5, '2026-04-12', 'Submetida', 600000.00, NULL, NULL),
(5, 5, 2, '2026-05-20', 'Em Avaliação', 850000.00, NULL, NULL);

-- 8. Inserir Telefones dos Beneficiários
INSERT INTO beneficiario_telefone
(id_beneficiario, telefone)
VALUES
(1,'225082001'),
(1,'225082002'),
(2,'253111111'),
(3,'910000000'),
(3,'910000001'),
(4,'140000000'),
(5,'301234567');

-- Q1: Quais os programas de financiamento atualmente disponíveis?

SELECT
    p.nome AS Programa,
    a.nome AS Area,
    t.descricao AS TipoFinanciamento,
    e.nome AS EntidadeGestora,
    p.orcamento_total AS Orcamento_Total,
    p.data_fecho AS Data_Fecho
FROM programa p
JOIN area_financiamento a
    ON p.id_area = a.id
JOIN tipo_financiamento t
    ON p.id_tipo_financiamento = t.id
JOIN entidade_gestora e
    ON p.id_entidade_gestora = e.id
WHERE p.estado = 'Aberto';


-- Q2: Que entidade gestora é responsável por cada programa?

SELECT p.nome AS Programa, e.nome AS Entidade_Gestora 
FROM programa p
JOIN entidade_gestora e ON p.id_entidade_gestora = e.id
ORDER BY p.nome;


-- Q3: Que beneficiários apresentaram candidaturas a determinado programa?

SELECT
    b.nome AS Beneficiario,
    p.nome AS Programa,
    e.nome AS Estado_Membro
FROM candidatura c
INNER JOIN beneficiario b
    ON c.id_beneficiario = b.id
INNER JOIN programa p
    ON c.id_programa = p.id
INNER JOIN estado_membro e
    ON b.id_estado_membro = e.id
ORDER BY b.nome;

-- Q4: Qual o tipo e a área de financiamento de cada programa?

SELECT p.nome AS Programa, t.descricao AS Tipo_Financiamento, a.nome AS Area_Financiamento
FROM programa p
JOIN tipo_financiamento t ON p.id_tipo_financiamento = t.id
JOIN area_financiamento a ON p.id_area = a.id;

-- Q5: Qual o Estado-Membro de origem de cada beneficiário?

SELECT 
    b.nome AS Beneficiario,
    b.tipo AS Tipo,
    e.nome AS Estado_Membro
FROM beneficiario b
INNER JOIN estado_membro e
    ON b.id_estado_membro = e.id
ORDER BY b.nome;

-- Q6: Qual o estado atual de cada candidatura?

SELECT
    b.nome AS Beneficiario,
    p.nome AS Programa,
    c.estado,
    c.valor_aprovado,
    c.data_decisao
FROM candidatura c
INNER JOIN beneficiario b
    ON c.id_beneficiario = b.id
INNER JOIN programa p
    ON c.id_programa = p.id
ORDER BY b.nome;

-- Q7: Qual o valor total solicitado e aprovado por programa?

SELECT p.nome AS Programa, 
       SUM(c.valor_pedido) AS Total_Solicitado, 
       SUM(c.valor_aprovado) AS Total_Aprovado
FROM programa p
JOIN candidatura c ON p.id = c.id_programa
GROUP BY p.nome;

-- Q8: Quantas candidaturas foram submetidas por cada beneficiário?

SELECT
    b.nome AS Beneficiario,
    COUNT(c.id) AS TotalCandidaturas
FROM beneficiario b
LEFT JOIN candidatura c
    ON b.id = c.id_beneficiario
GROUP BY b.nome
ORDER BY TotalCandidaturas DESC, b.nome;

-- Q9: Quantos dias se encontram em análise as candidaturas ainda sem decisão?

SELECT
    b.nome AS Beneficiario,
    p.nome AS Programa,
    c.data_submissao,
    DATEDIFF(DAY, c.data_submissao, GETDATE()) AS Dias_Em_Analise
FROM candidatura c
INNER JOIN beneficiario b
    ON c.id_beneficiario = b.id
INNER JOIN programa p
    ON c.id_programa = p.id
WHERE c.data_decisao IS NULL;

-- Q10: Que programas não receberam qualquer candidatura?

SELECT p.nome AS Programa_Sem_Candidaturas
FROM programa p
LEFT JOIN candidatura c ON p.id = c.id_programa
WHERE c.id IS NULL;