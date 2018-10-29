# SrCidadão - Coletor de dados da Câmara dos Deputados

Biblioteca para Download de XMLs dos Serviços de Dados Abertos do Senado Federal e Processamento dos XMLspara um banco de Dados MySQL.

# Pré requisitos

  - Servidor MySql 5.6 ou superior.
  - PHP 7 ou superior.
  - Servidor Apache 2.2 ou Superior.

## Onde começar

### Via composer

Adicione SrCidadão ao composer.json.
```
$ composer require wagner-goncalves/srcidadao-coletor-Senado
```

E atualize o composer
```
$ composer update
```

# Instalação

  - Criar banco de dados "srcidadao", disponível [aqui](https://github.com/wagner-goncalves/srcidadao-coletor-senado/blob/master/db/senado.sql). 
  - Configurar conexão com o banco de dados e a pasta onde os arquivos XML serão baixados no arquivo /src/Senado/Config/.config.
  - Conceder permissão de escrita para a pasta configurada (.config) anteriormente para receber os XMLs baixados.
  - Configurar eventuais exceções de firewall, uma vez que a biblioteca conecta-se no site remoto da Câmara dos Deputados.

# Como usar

### Download e processamento de dados

Inicialização

```php
// Se instalado via composer, use este código para incluir autoloader no topo do projeto.
require 'vendor/autoload.php';

// SrCidadão namespace
use SrCidadao\Coletor\Senado\Downloader;
use SrCidadao\Coletor\Senado\Processor;

//Recupera variáveis de configuração
$dotenv = new Dotenv\Dotenv(__DIR__ . "/../src/Senado/Config/", ".config");
$dotenv->load();

//Codigo sequencial. Deve ser gerado na tabela Senado_processamento antes de iniciar o download e processamento.
$codProcessamento = 1; 

$downloader = new Downloader($codProcessamento); // Passo 1, download da XMLs
$processor = new Processor($codProcessamento); // Passo 2, processa XML para banco de dados
```

Senadores
```php
$result = $this->getDownloader(1)->obterSenadores(); //Obtém lista de senadores ativos
$result = $this->getProcessor(1)->obterSenadores(); //Processa para a tabela senado_senador
```
Matérias colocadas em votação no plenário
```php
$result = $this->getDownloader(1)->obterMaterias("20170130", "N"); //Obtém matérias (resumo) votadas em prenário (um XML por data de última movimentação) - Data no Formato Ymd, "N" -> Matéria com tramitação já finalizada
$result = $this->getProcessor(1)->obterMaterias();//Processa a lista de matérias para a tabela senado_materia 
```
Detalhes de maérias
```php
$result = $this->getDownloader(1)->obterMateriaPorID(); //Obtém detalhes de matérias votadas - Deve ser executado após processamento no exemplo anterior.
$result = $this->getProcessor(1)->obterMateriaPorID(); //Processa detalhes de matérias para a tabela senado_detalhemateria e senado_materiaassunto
```
Votação de cada senador nas matérias
```php
$result = $this->getDownloader(1)->obterVotacaoMateria(); //Obtém votação de cada senador - Deve ser executado 
$result = $this->getProcessor(1)->obterVotacaoMateria();; //Processa votos de cada senador na matéria para a tabela senado_votoparlamentar
```
Consulte classes de teste em /tests/DownloaderTest.php

Licença
----
LGPL-3.0
