<?php

    namespace SrCidadao\Coletor\Senado;


	use SrCidadao\Coletor\Senado\Config\Config;
	use SrCidadao\Coletor\Util\Util;
	use SrCidadao\Coletor\Util\HttpReader;
	use SrCidadao\Coletor\Util\MensagemSistema;
	use SrCidadao\Coletor\Senado\Downloader;

	class Processor{
		private $objDownloader;
		private $codProcessamento = 0;
		
		public function __construct($codProcessamento){
            $this->codProcessamento = $codProcessamento;
            $this->objDownloader = new Downloader($this->codProcessamento);
		}
		
		private function arquivoJaProcessado($arquivo){
			$path_parts = pathinfo($arquivo);
            $arquivo = $path_parts['dirname'] . "/OK-" . $path_parts['filename'] . "." . $path_parts['extension'];
            return file_exists($arquivo);
		}

		public function obterSenadores(){
			$objDB = null;
            $arquivo = "";            
            
			try{

				$objDB = Util::getDB();
				$arquivo = Util::defineNomeArquivo(__FUNCTION__, $this->codProcessamento);
				
				$xml = file_get_contents($arquivo);
				$sql = "CALL obterSenadores(?, ?)";
				$stmt = $objDB->pdo->prepare($sql);
				$stmt->bindParam(1, $xml, \PDO::PARAM_STR);
				$stmt->bindParam(2, $this->codProcessamento, \PDO::PARAM_INT);
				$stmt->execute();
                $error = $stmt->errorInfo();

				if(intval($error[0]) > 0) throw new \Exception($error[2]);   
       
				return ["arquivo" => $arquivo, "success" => true, "message" => "Processado com sucesso. Arquivo renomeado."];
			}catch(\Exception $e){                
                echo $e->getTraceAsString();
                return ["arquivo" => $arquivo, "success" => false, "message" => MensagemSistema::get("ERR_PROCESSAMENTO")];		
			}
		}     
		
		public function obterMaterias($data = "", $tramitando = "N"){
            $arquivo = "";     
            $respostas = array();
            if($data == "") $data = date("Ymd", strtotime("-1 day"));
            $temErro = false;

            $objDB = Util::getDB();

            try{                
                $dataArquivo = $data;
                $arquivo = Util::defineNomeArquivo(__FUNCTION__, $this->codProcessamento);

				$xml = file_get_contents($arquivo);
				$sql = "CALL obterMaterias(?, ?)";
				$stmt = $objDB->pdo->prepare($sql);
				$stmt->bindParam(1, $xml, \PDO::PARAM_STR);
				$stmt->bindParam(2, $this->codProcessamento, \PDO::PARAM_INT);
				$stmt->execute();
				$error = $stmt->errorInfo();
				if(intval($error[0]) > 0) throw new \Exception($error[2]);   
				
                $respostas[] = ["arquivo" => $arquivo, "success" => true, "message" => MensagemSistema::get("SUS_PROCESSAMENTO")];
            }catch(\Exception $e){
                $temErro = true;
                echo $e->getTraceAsString();
                $respostas[] = ["arquivo" => $arquivo, "success" => false, "message" => MensagemSistema::get("ERR_DOWNLOAD")];		
            }                    
			
			return ["success" => !$temErro, "data" => $respostas];	
		}
        
		public function obterMateriaPorID(){
            $arquivo = "";  			
            $respostas = array();              
            $objDB = null;
            $temErro = false;

            $arrCodigoMateria = $this->objDownloader->listarMaterias($this->codProcessamento);

            $objDB = Util::getDB();

            foreach($arrCodigoMateria as $item){
                try{
                    $codMateria = ("-" . $item);
                    $arquivo = Util::defineNomeArquivo(__FUNCTION__, $this->codProcessamento, $codMateria);
                    
                    if(is_file($arquivo)){
						
						$xml = file_get_contents($arquivo);
						$sql = "CALL obterMateriaPorID(?, ?)";
						$stmt = $objDB->pdo->prepare($sql);
						$stmt->bindParam(1, $xml, \PDO::PARAM_STR);
						$stmt->bindParam(2, $this->codProcessamento, \PDO::PARAM_INT);
						$stmt->execute();
						$error = $stmt->errorInfo();
						if(intval($error[0]) > 0) throw new \Exception($error[2]);   
						
                        
                        $respostas[] = ["arquivo" => $arquivo, "success" => true, "message" => MensagemSistema::get("SUS_PROCESSAMENTO")];
                    }
                }catch(\Exception $e){
                    $temErro = true;
                    echo $e->getTraceAsString();
                    $respostas[] = ["arquivo" => $arquivo, "success" => false, "message" => MensagemSistema::get("ERR_DOWNLOAD")];		
                }                            
            }
            
			return ["success" => !$temErro, "data" => $respostas];	
		}
        
		public function obterVotacaoMateria(){
            $arquivo = "";  	            

			$respostas = array();
			$objDB = null;
            $arrCodigoMateria = $this->objDownloader->listarMaterias($this->codProcessamento);
            $temErro = false;
            $objDB = Util::getDB();

            $i = 0;
            foreach($arrCodigoMateria as $codigoMateria){
                try{
                    $arquivo = Util::defineNomeArquivo(__FUNCTION__, $this->codProcessamento, "-" . $codigoMateria);

                    if(is_file($arquivo)){
                        $xml = file_get_contents($arquivo);
                        $sql = "CALL senadoVotos(?, ?)";
                        $stmt = $objDB->pdo->prepare($sql);
                        $stmt->bindParam(1, $xml, \PDO::PARAM_STR);
                        $stmt->bindParam(2, $this->codProcessamento, \PDO::PARAM_INT);
                        $stmt->execute();
                        $error = $stmt->errorInfo();
                        
                        if(intval($error[0]) > 0) throw new \Exception($error[2]);                               
						
                        					
                        $respostas[] = ["arquivo" => $arquivo, "success" => true, "message" => MensagemSistema::get("SUS_PROCESSAMENTO")];
                    }
                }catch(\Exception $e){      
                    $temErro = true;
                    echo $e->getTraceAsString();                  
                    $respostas[] = ["arquivo" => $arquivo, "success" => false, "message" => MensagemSistema::get("ERR_DOWNLOAD")];		
                }
                $i++;
            }

			return ["success" => !$temErro, "data" => $respostas];
		}        
        
	}
