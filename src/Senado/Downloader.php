<?php

    namespace SrCidadao\Coletor\Senado;

	use SrCidadao\Coletor\Senado\Config\Config;
    use SrCidadao\Coletor\Util\Util;
    use SrCidadao\Coletor\Util\HttpReader;
	use SrCidadao\Coletor\Util\MensagemSistema;

	class Downloader{

		private $codProcessamento;
		
		public function __construct($codProcessamento = 0){
			$this->codProcessamento = $codProcessamento;
		}   

		public function obterSenadores(){
            $arquivo = "";

			try{

                $objConfig = new Config();
                $arquivo = Util::defineNomeArquivo(__FUNCTION__, $this->codProcessamento);
                if(!file_exists($arquivo)){
				    $objHttpReader = new HttpReader($objConfig->getUrl(__FUNCTION__, "Url"));
                    $objHttpReader->urlSave($arquivo);
                }

                return ["arquivo" => $arquivo, "success" => true, "message" => MensagemSistema::get("SUS_DOWNLOAD")];
			}catch(\Exception $e){
                echo $e->getTraceAsString();
                return ["arquivo" => $arquivo, "success" => false, "message" => MensagemSistema::get("ERR_DOWNLOAD")];
			}
		}

		public function obterMaterias($data = "", $tramitando = "N"){
            $arquivo = "";
            $temErro = false;
			$respostas = array();
            if($data == "") $data = date("Ymd", strtotime("-1 day"));

            $dataArquivo = $data;
            try{
                $objConfig = new Config();
                if($data != "") $objConfig->setParametroUrl(__FUNCTION__, "data", $data);
                $objConfig->setParametroUrl(__FUNCTION__, "tramitando", $tramitando);
                $arquivo = Util::defineNomeArquivo(__FUNCTION__, $this->codProcessamento);

                if(!file_exists($arquivo)){
                    $objHttpReader = new HttpReader($objConfig->getUrl(__FUNCTION__, "Url"));
                    $objHttpReader->urlSave($arquivo);
                }

                $respostas[] = ["arquivo" => $arquivo, "success" => true, "message" => MensagemSistema::get("SUS_DOWNLOAD")];
            }catch(\Exception $e){
                $temErro = true;
                echo $e->getTraceAsString();
                $respostas[] = ["arquivo" => $arquivo, "success" => false, "message" => MensagemSistema::get("ERR_DOWNLOAD")];
            }
            return ["success" => !$temErro, "data" => $respostas];	
		}

		public function obterMateriaPorID(){
            $arquivo = "";
            $arrCodigoMateria = $this->listarMaterias();

            $respostas = array();
            $temErro = false;
            
            foreach($arrCodigoMateria as $item){
                try{
                    $objConfig = new Config();
                    $objConfig->setParametroUrlInline(__FUNCTION__, "codMateria", $item);

                    $codMateria = ("-" . $item);
                    $arquivo = Util::defineNomeArquivo(__FUNCTION__, $this->codProcessamento, $codMateria);

                    if(!is_file($arquivo)){
                        echo $objConfig->getUrl(__FUNCTION__, "Url");
                        $objHttpReader = new HttpReader($objConfig->getUrl(__FUNCTION__, "Url"));
                        $objHttpReader->urlSave($arquivo);
                        $respostas[] = ["arquivo" => $arquivo, "success" => true, "message" => MensagemSistema::get("SUS_DOWNLOAD")];
                    }
                }catch(\Exception $e){
                    $temErro = true;
                    echo $e->getTraceAsString();
                    $respostas[] = ["arquivo" => $arquivo, "success" => false, "message" => MensagemSistema::get("ERR_DOWNLOAD")];
                }
            }

            if(count($respostas) == 0){
                $respostas[] = ["arquivo" => $arquivo, "success" => true, "message" => MensagemSistema::get("SUS_DOWNLOAD")];
            }

			return ["success" => !$temErro, "data" => $respostas];	
		}

		public function listarMaterias(){
			$objDB = Util::getDB();
			$arrCodProposicao = $objDB->select("senado_materia", "CodigoMateria", array("codProcessamento" => $this->codProcessamento));
			return $arrCodProposicao;
		}

		public function obterVotacaoMateria(){

            $arquivo = "";
			$respostas = array();
            $temErro = false;

            $arrCodigoMateria = $this->listarMaterias();

            foreach($arrCodigoMateria as $codMateria){
                try{
                    $objConfig = new Config();
                    $objConfig->setParametroUrlInline(__FUNCTION__, "codMateria", $codMateria);

                    $arquivo = Util::defineNomeArquivo(__FUNCTION__, $this->codProcessamento, ("-" . $codMateria));

                    if(!is_file($arquivo)){
                        $objHttpReader = new HttpReader($objConfig->getUrl(__FUNCTION__, "Url"));
                        $objHttpReader->urlSave($arquivo);
                        $respostas[] = ["arquivo" => $arquivo, "success" => true, "message" => MensagemSistema::get("SUS_DOWNLOAD")];
                    }
                }catch(\Exception $e){
                    $temErro = true;
                    echo $e->getTraceAsString();
                    $respostas[] = ["arquivo" => $arquivo, "success" => false, "message" => MensagemSistema::get("ERR_DOWNLOAD")];
                }
            }

            if(count($respostas) == 0){
                $respostas[] = ["arquivo" => $arquivo, "success" => true, "message" => MensagemSistema::get("SUS_DOWNLOAD")];
            }

			return ["success" => !$temErro, "data" => $respostas];	
		}
	}