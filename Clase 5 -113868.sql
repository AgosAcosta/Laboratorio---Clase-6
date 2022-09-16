use libreria_113868
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
select v.cod_vendedor, sum (d.cantidad*d.pre_unitario) 'total'
from facturas f 
join detalle_facturas d on d.nro_factura = f.nro_factura
join vendedores v on v.cod_vendedor = f.cod_vendedor

group by v.cod_vendedor

---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------

--2. Por cada factura emitida mostrar la cantidad total de artículos vendidos (suma de las cantidades vendidas), la cantidad ítems que tiene cada
--factura en el detalle (cantidad de registros de detalles) y el Importe total de la facturación de este año


SELECT SUM(cantidad) ' CANTIDAD DE ART', COUNT (F.nro_factura) 'CANT ITEMS',  sum(df.cantidad*df.pre_unitario)  ' IMPORTE TOTAL'
from facturas f
join detalle_facturas df on df.nro_factura = f.nro_factura
WHERE YEAR (FECHA) = YEAR (GETDATE()) 


---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
--3. Se quiere saber en este negocio, cuánto se factura:
--a. Diariamente

select  DAY(MAX(FECHA)), SUM (df.cantidad*df.pre_unitario) ' TOTAL'
from facturas f
join detalle_facturas df on df.nro_factura = f.nro_factura
WHERE DAY(FECHA) = GETDATE()
group by f.fecha
--------------------------------
SELECT FECHA
FROM facturas
WHERE FECHA BETWEEN '01/08/2022' AND '26/08/2022'
---------------------------------------------------


--b. Mensualmente
SELECT MONTH(MAX(FECHA)), sum(df.cantidad*df.pre_unitario) ' TOTAL'
from facturas F
join detalle_facturas df on df.nro_factura = f.nro_factura
WHERE MONTH (F.FECHA) = MONTH (GETDATE())
--group by MONTH(FECHA)

--c. Anualmente

SELECT YEAR(MAX(FECHA))'FECHA' ,sum(df.cantidad*df.pre_unitario) ' TOTAL'
from facturas F
join detalle_facturas df on df.nro_factura = f.nro_factura
WHERE YEAR(F.FECHA) = YEAR (GETDATE())

--GROUP BY YEAR(fecha)
ORDER BY 1

----------------------------------------------------------------------------------------
--CUAL FUE EL MONTO VENDIDO POR CADA VENDEDOR A CADA CLIENTE EL AÑO PASADO
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------


SELECT V.nom_vendedor 'NOMBRE VENDEDOR', sum(d.cantidad*d.pre_unitario) ' TOTAL', C.nom_cliente+ '  ' + C.ape_cliente
from facturas f 
join detalle_facturas d on d.nro_factura = f.nro_factura
join vendedores v on v.cod_vendedor = f.cod_vendedor
JOIN clientes C ON C.cod_cliente = F.cod_cliente

WHERE DATEDIFF ( YEAR, F.FECHA, GETDATE())= 1 -- YEAR(FECHA) = YEAR (GETDATE())-1
GROUP BY V.nom_vendedor,C.nom_cliente, C.ape_cliente

------------------- EJEMPLO HAVING ---------------------------
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------

SELECT F.nro_factura, sum(cantidad*pre_unitario) ' TOTAL'
FROM FACTURAS F
JOIN detalle_facturas DF ON F.nro_factura = DF.nro_factura
GROUP BY F.nro_factura

HAVING sum(cantidad*pre_unitario) BETWEEN 25 AND 890
ORDER BY 2
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
-------------------- 
-- QUE VENDEDORES VENDIERON MENOS DE $20.000 EN TOTAL, ESTE AÑO  Y CUAL ES EL MONTO

SELECT V.nom_vendedor 'NOMBRE VENDEDOR', sum(d.cantidad*d.pre_unitario) ' TOTAL'
from facturas f 
join detalle_facturas d on d.nro_factura = f.nro_factura
join vendedores v on v.cod_vendedor = f.cod_vendedor
WHERE YEAR (FECHA) = YEAR (GETDATE()) 

GROUP BY V.nom_vendedor
HAVING sum(d.cantidad*d.pre_unitario) > 20000 -- MENOR NO HAY 

-- ESTE ANO Y EL ANTERIOR 

SELECT V.nom_vendedor 'NOMBRE VENDEDOR', sum(d.cantidad*d.pre_unitario) ' TOTAL'
from facturas f 
join detalle_facturas d on d.nro_factura = f.nro_factura
join vendedores v on v.cod_vendedor = f.cod_vendedor
WHERE YEAR (FECHA) = YEAR (GETDATE()) 

GROUP BY V.nom_vendedor
HAVING sum(d.cantidad*d.pre_unitario) < 135000 -- MENOR NO HAY 
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
--4. Emitir un listado de la cantidad de facturas confeccionadas diariamente,
--correspondiente a los meses que no sean enero, julio ni diciembre.
--Ordene por la cantidad de facturas en forma descendente y fecha.
SELECT FECHA ' FEHCA FACTURA', COUNT( F.nro_factura) 'CANTIDAD FAC'
from facturas f 
join detalle_facturas d on d.nro_factura = f.nro_factura
WHERE MONTH(F.FECHA) NOT IN (1,7,12)
GROUP BY fecha,F.nro_factura
ORDER BY F.nro_factura DESC

-- 2021 
SELECT FECHA ' FEHCA FACTURA', COUNT( F.nro_factura) 'CANTIDAD FAC'
from facturas f 
join detalle_facturas d on d.nro_factura = f.nro_factura
WHERE MONTH(F.FECHA) NOT IN (1,7,12) and year(f.fecha)=2021
GROUP BY fecha,F.nro_factura
ORDER BY F.nro_factura DESC




---------------------------------listados de art cuyos precios son menores al promedio------------------------------------------------------------
select descripcion, observaciones 
from articulos
where pre_unitario < (select avg(pre_unitario) from articulos)


-- guia 1 pag 4 eje 2

--Se quiere saber qué vendedores y clientes hay en la empresa; para los casos en que su teléfono y dirección de e-mail sean conocidos. Se deberá visualizar el
--código, nombre y si se trata de un cliente o de un vendedor. Ordene por la columna tercera y segunda.

select cod_cliente 'codigo', nom_cliente + ' , ' + ape_cliente 'nombre', 'clientes' tipo
from clientes
where nro_tel is not null  and [e-mail] is not null
union
select cod_vendedor 'codigo' , nom_vendedor + ' , ' + ape_vendedor 'nombre', 'vendedor' 
from vendedores
where nro_tel is not null  and [e-mail] is not null
order by 3,2

------------------------------------ TEST DE PERTENENCIA  IN  valor que pertenece a un conjunto ---------------------------------------------------

--Listar los datos de los clientes que compraron este año:
SELECT *
FROM clientes
WHERE cod_cliente IN (SELECT cod_cliente                       FROM facturas 					  WHERE YEAR(fecha) = YEAR(GETDATE()))-- listar los datos de los clientes que no compraron el año pasado.select cod_cliente codigo, ape_cliente + ','+ nom_clientefrom clienteswhere cod_cliente not in (select cod_cliente                           from facturas 						  where year(fecha) = year (getdate()) - 1)---------------------------------------- TEST DE EXISTENCIA (MUY SIMILAR A IN)  EXISTS UN VALOR CUMPLE CON UNA CCONDICION ----------------------------------------------------------Listar los datos de los clientes que compraron este añoSELECT cod_cliente Código, ape_cliente +' '+ nom_cliente Nombre
 FROM clientes c
WHERE EXISTS (SELECT cod_cliente -- subconsulta
              FROM facturas f
              WHERE c.cod_cliente = f.cod_cliente
              AND YEAR(fecha) = YEAR(GETDATE())
)-- Listar los datos de los clientes que no compraron el año pasadoSELECT cod_cliente Código, ape_cliente +' '+ nom_cliente Nombre
 FROM clientes c
WHERE NOT EXISTS (SELECT cod_cliente
                  FROM facturas f
                  WHERE c.cod_cliente = f.cod_cliente
                  AND YEAR(fecha) = YEAR(GETDATE()) -1
)---------------------------------------------TEST CUANTIFICADOS -------------------------------------------------  ANY ALGUNOS //  ALL TODOS Comprubea que todas la comparaciones sean verdaderas-- Listar los clientes que alguna vez compraron un producto menor a $ 10.-  // ANYSELECT cod_cliente Código, ape_cliente +' '+ nom_cliente Nombre
 FROM clientes c where 10 > any (select pre_unitario                 from facturas f join detalle_facturas df on df.nro_factura = f.nro_factura 			     where c.cod_cliente = f.cod_cliente)-- Listar los clientes que siempre fueron atendidos por el vendedor 3select cod_cliente codigo, ape_cliente + ' , ' + nom_cliente nombrefrom clientes cwhere 3 = all ( select cod_vendedor                from facturas f				where c.cod_cliente = f.cod_cliente)---------------------------------------------------------------- GUIA 2 EJE 2----------------------------------- CORRECTOSELECT   A.cod_articulo ' CODIGO',  A.pre_unitario, descripcionFROM articulos AWHERE A.pre_unitario BETWEEN 50 AND 100AND A.cod_articulo NOT IN (SELECT cod_articulo                           FROM Detalle_facturas df JOIN FACTURAS F  ON F.nro_factura = DF.nro_factura						   WHERE YEAR (F.FECHA) = YEAR( GETDATE()))-- Emitir un listado de los artículos que no fueron vendidos este año. En ese listado solo incluir aquellos cuyo precio unitario del artículo oscile entre 50 y 100. --SELECT   A.cod_articulo ' CODIGO', observaciones 'OBSERVACIONES', A.pre_unitario--FROM articulos A--WHERE cod_articulo IN( SELECT DF.cod_articulo	--                       FROM detalle_facturas df JOIN FACTURAS F  ON F.nro_factura = DF.nro_factura--					   WHERE YEAR (F.FECHA) != YEAR( GETDATE()) AND A.pre_unitario BETWEEN 50 AND 100)--MALLL ----- SELECT  DISTINCT A.cod_articulo ' CODIGO', observaciones 'OBSERVACIONES', A.pre_unitario, FECHA	--FROM articulos A--JOIN detalle_facturas df on df.cod_articulo = A.cod_articulo --JOIN facturas F ON F.nro_factura = DF.nro_factura--WHERE F.nro_factura NOT IN (SELECT nro_factura FROM FACTURAS WHERE YEAR(FECHA) = YEAR(GETDATE()))--AND A.pre_unitario BETWEEN 50 AND 100 --------------- eje 3-- Genere un reporte con los clientes que vinieron más de 2 veces el año pasado.select cod_cliente codigo, ape_cliente + ' , ' + nom_cliente nombrefrom clientes cwhere c.cod_cliente in ( select cod_cliente from facturas f join detalle_facturas df on F.nro_factura = DF.nro_facturawhere year (fecha) = year (getdate()) -1 group by 1------------------------------------------- Eje 1.4 (2)--Se desea un listado de vendedores y sus importes de ventas del año 2017 pero solo aquellos que vendieron menos de $ 17.000.- en dicho añoselect v.cod_vendedor, v.ape_vendedor + ' , ' + v.nom_vendedor Nombre, sum (df.cantidad* df.pre_unitario),year( f.fecha)from vendedores vjoin facturas f on f.cod_vendedor = v.cod_vendedorjoin detalle_facturas df on df.nro_factura = f.nro_facturawhere year(f.fecha) = 2017group by v.cod_vendedor, v.ape_vendedor + ' , ' + v.nom_vendedor,year( f.fecha)having sum (df.cantidad* df.pre_unitario)<17000-- Emitir un listado que muestre la cantidad total de artículos vendidos, el importe total vendido y el promedio del importe vendido por vendedor y por cliente; 
-- para los casos en que el importe total vendido esté entre 200 y 600 y para códigos de cliente que oscilen entre 1 y 5.select sum(cantidad) 'total de articulos', sum (df.pre_unitario * df.cantidad) 'total vendido', avg(df.pre_unitario * df.cantidad),  v.ape_vendedor + ' , ' + v.nom_vendedor Nombre, c.ape_cliente +' '+ c.nom_cliente Nombrefrom vendedores vjoin facturas f on f.cod_vendedor = v.cod_vendedorjoin detalle_facturas df on df.nro_factura = f.nro_facturajoin clientes c on c.cod_cliente = f.cod_clientewhere f.cod_cliente between 1 and 5group by v.ape_vendedor + ' , ' + v.nom_vendedor , c.ape_cliente +' '+ c.nom_cliente having  sum (df.pre_unitario * df.cantidad) between 5000 and 1000000--9. ¿Cuáles son los vendedores cuyo promedio de facturación el mes pasado supera los $ 800?select avg(df.pre_unitario * df.cantidad) ' promedio vendido', v.ape_vendedor + ' , ' + v.nom_vendedor Nombre, f.fechafrom vendedores vjoin facturas f on f.cod_vendedor = v.cod_vendedorjoin detalle_facturas df on df.nro_factura = f.nro_facturawhere datediff( month, f.fecha, getdate())=1 -- month (fecha) = month (getdate()) -1 and year (fecha) = year (getdate()) group by v.ape_vendedor + ' , ' + v.nom_vendedor, f.fechahaving avg(df.pre_unitario * df.cantidad)>800--10.¿Cuánto le vendió cada vendedor a cada cliente el año pasado siempre que la cantidad de facturas emitidas (por cada vendedor a cada cliente) sea menor a 5?--------------------------------------- SUBCONSULTAS CON HAVING ---------------------------------------------------listar los vendedores cuyas ventas totales sea superior al promedio general de ventas select sum (df.pre_unitario * df.cantidad) 'total vendido' , v.ape_vendedor + ' , ' + v.nom_vendedor Nombrefrom vendedores vjoin facturas f on f.cod_vendedor = v.cod_vendedorjoin detalle_facturas df on df.nro_factura = f.nro_facturagroup by v.ape_vendedor + ' , ' + v.nom_vendedor having avg(df.pre_unitario * df.cantidad) >  (select avg(pre_unitario * cantidad) from detalle_facturas)----- ejercicio 1--Se quiere saber ¿cuándo realizó su primer venta cada vendedor? y ¿cuánto fue el importe total de las ventas que ha realizado? Mostrar estos
--datos en un listado solo para los casos en que su importe promedio de vendido sea superior al importe promedio general (importe promedio de todas las facturas).

select  v.ape_vendedor + ' , ' + v.nom_vendedor Nombre, min(f.fecha)' fecha',sum (df.pre_unitario * df.cantidad) 'total vendido' , SUM(df.pre_unitario*df.cantidad) / COUNT( f.nro_factura) ' promedio ventas'from vendedores vjoin facturas f on f.cod_vendedor = v.cod_vendedorjoin detalle_facturas df on df.nro_factura = f.nro_facturagroup by v.ape_vendedor + ' , ' + v.nom_vendedorhaving sum (df.pre_unitario * df.cantidad) > (select AVG(pre_unitario*cantidad)from detalle_facturas)order by [fecha]select *
from facturas
 
 min(Month (f.fecha))'mes' ,min( year(f.fecha))'año'--guia 2 pagina 4, ejercicio 7--El encargado del negocio quiere saber cuánto fue la facturación del año pasado.
--Por otro lado, cuánto es la facturación del mes pasado, la de este mes y la de
--hoy (Cada pedido en una consulta distinta, y puede unirla en una sola tabla de
--resultado)

select sum(cantidad * pre_unitario) 'Facturacion',  'año'periodo 
from facturas fjoin detalle_facturas df on df.nro_factura = f.nro_facturawhere year(fecha) = year(GETDATE())-1 --and YEAR(fecha) = YEAR(getdate()) 
union
select sum(cantidad * pre_unitario) 'Facturacion', 'mes actual'periodo
from facturas fjoin detalle_facturas df on df.nro_factura = f.nro_facturawhere MONTH(fecha) = MONTH(GETDATE()) and YEAR(fecha) = year(GETDATE()) --and YEAR(fecha) = YEAR(getdate()) unionselect sum(cantidad * pre_unitario) 'Facturacion',  'mes anterior'periodo
from facturas fjoin detalle_facturas df on df.nro_factura = f.nro_facturawhere MONTH(fecha) = MONTH(GETDATE())-1 and YEAR(fecha) = year(GETDATE()) --and YEAR(fecha) = YEAR(getdate()) unionselect sum(cantidad * pre_unitario) 'Facturacion', 'hoy'periodo
from facturas fjoin detalle_facturas df on df.nro_factura = f.nro_facturawhere fecha = GETDATE()  --and YEAR(fecha) = YEAR(getdate()) --2. Liste los montos totales mensuales facturados por cliente y además del promedio de ese monto y el promedio de precio de artículos Todos esto
--datos correspondientes a período que va desde el 1° de febrero al 30 de agosto del 2014. 
--Sólo muestre los datos si esos montos totales son superiores o iguales al promedio global. (Se modifico fecha)



Select  c.nom_cliente+' , ' +c.ape_cliente 'Cliente',month (f.fecha)'mes', year(f.fecha)'año',sum (df.pre_unitario * df.cantidad) 'total vendido', avg(df.pre_unitario * df.cantidad)'Promedio de ventas', AVG(df.pre_unitario) 'Promedio Precio Art.'
from facturas f 
join detalle_facturas df on f.nro_factura = df.nro_factura
join clientes c on f.cod_cliente = c.cod_cliente
Where f.fecha between '01/02/2014' and '30/08/2022'
group by c.nom_cliente+' , ' +c.ape_cliente ,month (f.fecha), year(f.fecha)
having sum (df.pre_unitario * df.cantidad) >= (select AVG(pre_unitario*cantidad)from detalle_facturas)
order by 3

select a.descripcion, a.pre_unitario * 0.965
from articulos a
where 5 > any (select sum(df.cantidad)
			   from detalle_facturas df
			   join facturas f on f.nro_factura = df.nro_factura
			   where MONTH(f.fecha)=month(getdate())-3
			   group by df.cod_articulo)


------------------------------------------------------SUBCONSULTA EN SELECT -----------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------
--se quiere listar el precio de los artículos y la diferencia de éste con el precio del artículo más caro: (PAG 7 UNIDAD 2)

SELECT descripcion, pre_unitario, (SELECT MAX(pre_unitario) FROM articulos) - pre_unitario 'DIFERENCIA'
FROM articulos

------------------------------------------------------SUBCONSULTA EN FROM -----------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------

--RETORNAR UN CONJUNTO DE REGISTROS EN EL FROM 

--LISTAR DE LAS FACTURAS DEL AÑO EN CURSO DETALLANDO SUS DATOS Y TOTAL 

SELECT F.nro_factura, fecha, ape_cliente, nom_cliente, f2.TOTAL
FROM facturas F JOIN clientes C ON C.cod_cliente = F.cod_cliente
JOIN (SELECT nro_factura, SUM (PRE_UNITARIO * CANTIDAD) FROM detalle_facturas GROUP BY nro_factura) AS f2 ON F2. nro_factura = F.nro_factura
WHERE YEAR (FECHA) = YEAR (GETDATE())

------------------------------------------------------SUBCONSULTA EN UPDATE Y DELETE -----------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------
-- se quiere aumentar un 5% los precios de los artículos cuyos precios son inferiores al promedio general 
UPDATE articulos
 SET pre_unitario = pre_unitario*1.05
WHERE pre_unitario < (SELECT AVG(pre_unitario)
                      FROM articulos)


-- se quiere eliminar los clientes que no vinieron nunca.

DELETE clientes
WHERE cod_cliente NOT IN (SELECT cod_cliente
                          FROM facturas)

-- vendedores que no vendieron nada 

DELETE vendedores
WHERE cod_vendedor NOT IN ( SELECT cod_vendedor FROM facturas)