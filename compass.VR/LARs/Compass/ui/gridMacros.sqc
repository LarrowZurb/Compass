
#define scaleFactor getNumber( configFile >> "uiScaleFactor" )
//#define gridScale ( uiNamespace getVariable[ "LARs_pixelGrid_gridScale", 1 ] )

//Changable grids based on user input
#define GRID_X( num, gridScale ) ( pixelW * pixelGrid *((( num ) * ( gridScale )) / scaleFactor ))
#define GRID_Y( num, gridScale ) ( pixelH * pixelGrid *((( num ) * ( gridScale )) / scaleFactor ))

//Grids for user interface
#define GRIDNOSCALE_X( num ) ( pixelW * pixelGrid *((( num ) * 8 ) / scaleFactor ))
#define GRIDNOSCALE_Y( num ) ( pixelH * pixelGrid *((( num ) * 8 ) / scaleFactor ))

#define VERTICAL_GUTTER GRID_Y( 2, 8 )