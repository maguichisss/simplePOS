<?php

class PDF extends Fpdf{

  public $fechaInicio=null;
  public $fechaFin;
  public $ticket=false;
  public $idVenta;

  function __construct($orientacion, $unidad, $formato){
    parent::__construct($orientacion, $unidad, $formato);
  }


  function Header(){ //función header
    //formateamos la fecha de hoy
      $dias = array("Domingo","Lunes","Martes","Miercoles",
              "Jueves","Viernes","Sábado");
      $meses = array("Enero","Febrero","Marzo","Abril",
            "Mayo","Junio","Julio","Agosto",
            "Septiembre","Octubre","Noviembre","Diciembre");
      $hoy= $dias[date('w')]." ".date('d').
          " de ".$meses[date('n')-1]. " del ".date('Y')." ".
          date("g:i a");

    $ruta=explode('/', __FILE__);
    for ($i=0; $i <3 ; $i++)
      array_pop($ruta);
    $ruta=implode('/', $ruta).'/images/logo.jpg';

    if ($this->ticket==true) {
      $this->SetAutoPageBreak(false);
      $this->SetMargins(1,1,1);
      $this->Image($ruta,10,2,16);
      $this->SetFont('Arial','B',2.5);
      $this->Cell(0,3,'',0,0,'');
      $empleado=DB::select(
          'call SPD_CONSULTA_EMPLEADO(?)',array(Session::get('idEmpleado')));
      $this->Ln();
      $this->Cell(20,3,'Fecha: '.$hoy,0,0,'');
      $this->Cell(20,3,'Folio: '.$this->idVenta,0,0,'');
      $this->Ln(2);
      $this->Cell(15,3,'Vendedor: '.
              $empleado[0]->nombre.' '.
              $empleado[0]->apellido_paterno,0,0,'');
      $this->Ln(2);
      $this->Cell(20,3,'Sucursal: '.
              $empleado[0]->nombre_sucursal,0,0,'');
      $this->Ln(2);

    }else {
      $this->Image( $ruta,10,8,23);
      $this->Ln(5);
      $this->SetFont('Arial','B',4);
      $margenFecha=195;
      if (isset($empleado)) {
        $this->Cell(75,5,'Empleado: '.
                $empleado[0]->nombre.' '.
                $empleado[0]->apellido_paterno,0,0,'R');
        $this->Cell(30,5,' Usuario: '.
                $empleado[0]->username,0,0,'R');
        $this->Cell(30,5,' Sucursal: '.
                $empleado[0]->nombre_sucursal,0,0,'R');
        $margenFecha=60;
      }else{
        $empleado=DB::select(
          'call SPD_CONSULTA_EMPLEADO(?)',array(Session::get('idEmpleado')));
        $this->Cell(75,5,'Empleado: '.
                $empleado[0]->nombre.' '.
                $empleado[0]->apellido_paterno,0,0,'R');
        $this->Cell(30,5,' Usuario: '.
                Session::get('usuario'),0,0,'R');
        $this->Cell(30,5,' Sucursal: '.
                Session::get('sucursal'),0,0,'R');
        $margenFecha=60;
      }
      if (isset($sucursal)) {
        $this->Cell(135,5,'Sucursal: '.
                $sucursal->nombre_sucursal,0,0,'R');
        $margenFecha=60;
      }
      $this->Cell($margenFecha,5,'Fecha: '.$hoy,0,0,'R');
      $this->Ln(5);
      $aux='Corte de Caja de: '.$this->fechaInicio.' hasta: '.$this->fechaFin;
      $this->Cell(120,5,$aux,0,0,'L');
      $this->Ln(5);
    }
  }
 
  function Footer() { //función footer
    if ($this->ticket == false) {
      $this->SetY(-15); //posición en el pie. 1.5 cm del borde
      $this->SetFont("Arial", "I", 0); //tipo de letra
      //Texto del pie de página
      $this->Cell(0,10,  utf8_decode('Página '.$this->PageNo().' de {nb}') ,0,0,'C');
    }
  }

  public function setFechas($fi, $ff){
    $this->fechaInicio = $fi;
    $this->fechaFin = $ff;
  }

  public function setTicket($ticket){
    $this->ticket = $ticket;
  }
  public function setFolio($folio){
    $this->idVenta = $folio;
  }
}