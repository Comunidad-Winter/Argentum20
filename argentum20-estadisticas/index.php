<?php
  // include('functions.php');
  include('_statistics.php');
  // $pageData = getIndexPageData();
  $stats = getGeneralStats();
?>

<!DOCTYPE html>
<html lang="en">

  <head>
    <!-- Bootstrap core CSS -->
    <link href="./vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <link href="./vendor/bootstrap/css/bootswatch.min.css" rel="stylesheet">

    <!-- Favicon -->
    <link href="./css/cucsi.css" rel="stylesheet">
  <body>

    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
      <div class="container">
        <a class="navbar-brand" href="index.php"><img src="img/logo.png" /></a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarResponsive">
          <ul class="navbar-nav ml-auto">
            <li class="nav-item">
              <a class="nav-link" href="https://ao20.com.ar">Web</a>
              <a class="nav-link" href="https://test.ao20.com.ar">Web Test</a>
            </li>
          </ul>
        </div>
      </div>
    </nav>

    <!-- Page Content -->
    <div class="container">

      <div class="row">

        <!-- Blog Entries Column -->
        <div class="col-md-8">
          <h1 class="my-4">Estadisticas del servidor</h1>
          
          <div class="card mb-3">
            <div class="card-header">Estadisticas generales</div>
            <div class="card-body">
              <table class="table table-personaje">
                <tbody>
                  <tr>
                    <td>Cuentas creadas</td>
                    <td><?php echo $stats['accounts']; ?></td>
                  </tr>
                  <tr>
                    <td>Personajes creados</td>
                    <td><?php echo $stats['users']; ?></td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>

          <div class="card mb-3">
            <div class="card-header">Usuarios por clase</div>
            <div class="card-body">
            <figure class="highcharts-figure">
              <div id="chartUsuariosPorClase"></div>
            </figure>
            </div>
          </div>

          <div class="card mb-3">
            <div class="card-header">Clases por raza</div>
            <div class="card-body">
            <figure class="highcharts-figure">
              <div id="chartClasesPorRaza"></div>
            </figure>
            </div>
          </div>

          <div class="card mb-3">
            <div class="card-header">Usuarios matados por clase</div>
            <div class="card-body">
            <figure class="highcharts-figure">
              <div id="chartUsuariosMatadosPorClase"></div>
            </figure>
            </div>
          </div>

          <div class="card mb-3">
            <div class="card-header">Usuarios por nivel</div>
            <div class="card-body">
            <figure class="highcharts-figure">
              <div id="chartUsuariosPorLevel"></div>
            </figure>
            </div>
          </div>
          
          <div class="card mb-3">
            <div class="card-header">Usuarios online por hora</div>
            <div class="card-body">
            <figure class="highcharts-figure">
              <div id="chartUsuariosPorHora"></div>
            </figure>
            </div>
          </div>

        </div>

      </div>
      <!-- /.row -->
      <iframe src="https://steamdb.info/embed/?appid=1956740" height="389" style="border:0;overflow:hidden;width:100%" loading="lazy"></iframe>
    </div>
    <!-- /.container -->

    <!-- Bootstrap core JavaScript -->
    <script src="./vendor/jquery/jquery.min.js"></script>
    <script src="./vendor/popper/popper.min.js"></script>
    <script src="./vendor/bootstrap/js/bootstrap.min.js"></script>
    <script src="./vendor/Highcharts-8.0.4/code/highcharts.js"></script>
    <script src="./vendor/Highcharts-8.0.4/code/themes/dark-unica.js"></script>

    <script type="text/javascript">
       window.onload = () => {
        Highcharts.chart('chartUsuariosPorClase', {
          chart: {
              plotBackgroundColor: null,
              plotBorderWidth: null,
              plotShadow: false,
              type: 'pie'
          },
          title: {
              text: 'Usuarios por clase'
          },
          subtitle: {
              text: 'solo contando mayores a nivel 25'
          },
          tooltip: {
              pointFormat: '{series.name}: <b>{point.y}</b>'
          },
          accessibility: {
              point: {
                  valueSuffix: '%'
              }
          },
          plotOptions: {
              pie: {
                  allowPointSelect: true,
                  cursor: 'pointer',
                  dataLabels: {
                      enabled: false
                  },
                  showInLegend: true
              }
          },
          series: [{
              name: 'Usuarios',
              colorByPoint: true,
              data: <?php echo json_encode(getUsuariosPorClase()); ?>
          }]
        });

        Highcharts.chart('chartClasesPorRaza', {
          chart: {
              type: 'column'
          },
          title: {
              text: 'Clases por Raza'
          },
          subtitle: {
              text: 'solo contando mayores a nivel 25'
          },
          xAxis: {
              categories: [
                'Mago',
                'Clerigo',
                'Guerrero',
                'Asesino',
                'Ladrón',
                'Bardo',
                'Druida',
                'Bandido',
                'Paladin',
                'Cazador',
                'Trabajador',
                'Pirata'
              ],
              crosshair: true
          },
          yAxis: {
              min: 0,
              title: {
                  text: 'numero de usuarios'
              }
          },
          tooltip: {
              headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
              pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                  '<td style="padding:0"><b>{point.y} Pjs</b></td></tr>',
              footerFormat: '</table>',
              shared: true,
              useHTML: true
          },
          plotOptions: {
              column: {
                  pointPadding: 0.2,
                  borderWidth: 0
              }
          },
          series: <?php echo json_encode(getClasesPorRaza()); ?>
        });

        Highcharts.chart('chartUsuariosPorHora', {
          title: {
            text: 'Usuarios online'
          },
          subtitle: {
            text: 'promedio por hora'
          },
          yAxis: {
            title: {
              text: 'Cantidad de usuarios'
            },
            labels: {
                format: '{value.2f}'    
            }
          },
          xAxis: {
            title: {
              text: 'Hora'
            },
            categories: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23],
            step: 1,
            minRange: 1,
            labels: {
                format: '{value}hs'    
            }
          },
          tooltip: {
              headerFormat: '<b>{point.key}hs</b><br/>'
          },
          legend: {
              layout: 'horizontal',
              align: 'center',
              verticalAlign: 'bottom'
          },

          plotOptions: {
              series: {
                  label: {
                      connectorAllowed: false
                  },
                  pointStart: 0
              }
          },

          series: [{
              name: 'promedio de usuarios',
              color: '#7798BF',
              data: <?php echo json_encode(getUsuariosOnlinePorHora()); ?>
            },
          ],
          
          responsive: {
              rules: [{
                  condition: {
                      maxWidth: 500
                  },
                  chartOptions: {
                      legend: {
                          layout: 'horizontal',
                          align: 'center',
                          verticalAlign: 'bottom'
                      }
                  }
              }]
          }
        });
        
        Highcharts.chart('chartUsuariosPorLevel', {
          title: {
            text: 'Usuarios por nivel'
          },
          subtitle: {
            text: 'solo contando niveles mayores a 13'
          },
          yAxis: {
            title: {
              text: 'Cantidad de usuarios'
            }
          },
          xAxis: {
            title: {
              text: 'Nivel'
            }
          },
          legend: {
              layout: 'horizontal',
              align: 'center',
              verticalAlign: 'bottom'
          },

          plotOptions: {
              series: {
                  label: {
                      connectorAllowed: false
                  },
                  pointStart: 14
              }
          },

          series: [{
              name: 'Cantidad de usuarios',
              data: <?php echo json_encode(getUsuariosPorLevel()); ?>
          },],

          responsive: {
              rules: [{
                  condition: {
                      maxWidth: 500
                  },
                  chartOptions: {
                      legend: {
                          layout: 'horizontal',
                          align: 'center',
                          verticalAlign: 'bottom'
                      }
                  }
              }]
          }
        });

        const chartData = <?php echo json_encode(getKillsPorClase()); ?>;

        Highcharts.chart('chartUsuariosMatadosPorClase', {
          chart: {
              type: 'bar'
          },
          title: {
              text: 'Promedio de usuarios matados por clase'
          },
          subtitle: {
              text: 'solo contando niveles mayores o iguales a 25'
          },
          xAxis: {
            categories: chartData.map(x => x.name),
            title: {
              text: 'Clase'
            }
          },
          yAxis: {
              min: 0,
              title: {
                text: 'Promedio usuarios matados',
                align: 'high'
              },
              labels: {
                overflow: 'justify'
              }
          },
          tooltip: {
            valueSuffix: ''
          },
          plotOptions: {
            bar: {
                dataLabels: {
                    enabled: true
                }
            }
          },
          legend: {
              layout: 'vertical',
              align: 'right',
              verticalAlign: 'top',
              x: -40,
              y: 80,
              floating: true,
              borderWidth: 1,
              backgroundColor:
                  Highcharts.defaultOptions.legend.backgroundColor || '#FFFFFF',
              shadow: true
          },
          credits: {
              enabled: false
          },
          series: [{
            name: 'Usuarios Matados',
            data: chartData.map(x => x.y)
          }]
        });
      };
    </script>
  </body>
</html>
