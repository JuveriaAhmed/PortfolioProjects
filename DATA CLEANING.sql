
-- Data cleaning

-- Standardize Date format
select saledateconverted
from NashvilleHousing

--select SaleDate, convert(date,saleDate) 
--from NashvilleHousing

--update NashvilleHousing
--set SaleDate = convert(date,saleDate) 

alter table nashvillehousing
add saledateconverted Date;

update NashvilleHousing
set saledateconverted = convert(date,saleDate) 


-- populating the property address data

select propertyaddress
from NashvilleHousing


select a.ParcelID, a.propertyaddress, b.ParcelID, b.propertyaddress, ISNULL(a.propertyaddress, b.propertyaddress)
from NashvilleHousing a
join NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

update a
set propertyaddress = ISNULL(a.propertyaddress, b.propertyaddress)
from NashvilleHousing a
join NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

-- seperating the address into individual columns (address,city,state)

select SUBSTRING(propertyaddress, 1, charindex(',' , propertyaddress)-1) as address,
SUBSTRING(propertyaddress, charindex(',' , propertyaddress) +1, len(propertyaddress)) as address
from NashvilleHousing

alter table nashvillehousing
add propertysplitaddress nvarchar (255)

update NashvilleHousing
set PropertysplitAddress = SUBSTRING(propertyaddress, 1, charindex(',' , propertyaddress)-1) 

--select propertysplitaddress
--from NashvilleHousing


alter table nashvillehousing
add propertysplitcity nvarchar (255)

update NashvilleHousing
set Propertysplitcity = SUBSTRING(propertyaddress, charindex(',' , propertyaddress) +1, len(propertyaddress))

select propertysplitcity
from NashvilleHousing