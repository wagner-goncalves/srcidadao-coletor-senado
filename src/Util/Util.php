<?php

namespace SrCidadao\Coletor\Util;

use SrCidadao\Coletor\Senado\Config\Config;
use Medoo\Medoo;

class Util{

    public static function defineNomeArquivo($funcao, $codProcessamento = 0, $adicionais = ""){
        $base = Config::getDownloderBaseFilePath();
        $nome = ($base . str_pad(intval($codProcessamento), 4, 0, STR_PAD_LEFT) . "-" . $funcao . $adicionais . ".xml");
        return $nome;
    }

    public static function getDB(){
        return new Medoo(Config::getDatabaseSettings());
    }    
}