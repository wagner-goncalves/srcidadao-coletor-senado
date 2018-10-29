<?php

//Recupera variáveis do ambiente
$dotenv = new Dotenv\Dotenv(__DIR__ . "/../src/Senado/Config/", ".config");
$dotenv->load();

use PHPUnit\Framework\TestCase;

/**
 *  @author Wagner Gonçalves
 */
class DownloaderTest extends TestCase
{

    private function getDownloader($codProcessamento)
    {
        return new SrCidadao\Coletor\Senado\Downloader($codProcessamento);
    }

    private function getProcessor($codProcessamento)
    {
        return new SrCidadao\Coletor\Senado\Processor($codProcessamento);
    }

    public function testObterSenadores()
    {
        $result = $this->getDownloader(1)->obterSenadores();
        $this->assertTrue($result["success"]);

        $result = $this->getProcessor(1)->obterSenadores();
        $this->assertTrue($result["success"]);
    }

    public function testObterMaterias()
    {
        $result = $this->getDownloader(1)->obterMaterias("20170130", "N"); //Matérias movimentadas a partir de 30/01/2017 e que já fora finalizadas -> Tramitando = "N"
        $this->assertTrue($result["success"]);

        $result = $this->getProcessor(1)->obterMaterias();
        $this->assertTrue($result["success"]);
    }

    public function testObterMateriaPorID()
    {
        $result = $this->getDownloader(1)->obterMateriaPorID();
        $this->assertTrue(is_array($result));

        $result = $this->getProcessor(1)->obterMateriaPorID();
        $this->assertTrue(is_array($result));
    }

    public function testObterVotacaoMateria()
    {
        $result = $this->getDownloader(1)->obterVotacaoMateria();
        $this->assertTrue(is_array($result));

        $result = $this->getProcessor(1)->obterVotacaoMateria();
        $this->assertTrue(is_array($result));
    }

}
