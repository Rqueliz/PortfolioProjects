-- Change Y  And N to Yes  and NO in "Sold as Vacant" Field
use [Portfolio Project]
Select * from [Portfolio Project]. dbo.nashvillehousing

-- Standardize Date Format

Select saledateconverted , CONVERT(date,saledate)
from [Portfolio Project]. dbo.nashvillehousing

Update NashvilleHousing
SET saledate =  CONVERT(date,saledate) 

ALTER TABLE nashvillehousing 
Add saledateconverted date; 

Update nashvillehousing
SET saledateconverted =  CONVERT(date,saledate) 


--Populate Property Address Data 

Select *
from [Portfolio Project]. dbo.nashvillehousing
--where propertyaddress is null
order by parceLId


Select a.ParcelID, a.propertyAddress, b.parcelID, b.propertyAddress, isnull(a.propertyaddress,b.propertyAddress)
from [Portfolio Project]. dbo.nashvillehousing A
JOIN [Portfolio Project]. dbo.nashvillehousing B
  ON a.parcelid = b.parcelid
  and a.[uniqueID ] <> b.[uniqueID ]
  where a.propertyAddress is null


  Update A
  Set propertyaddress =  isnull(a.propertyaddress,b.propertyAddress)
  from [Portfolio Project]. dbo.nashvillehousing A
JOIN [Portfolio Project]. dbo.nashvillehousing B
  ON a.parcelid = b.parcelid
  and a.[uniqueID ] <> b.[uniqueID ]
  where a.propertyAddress is null

  --Breaking out Address into individual columns (Address, city, State)

  Select propertyaddress
from [Portfolio Project]. dbo.nashvillehousing
--where propertyaddress is null
--order by parceLId

Select 
Substring(propertyaddress, 1, Charindex(',', propertyaddress) -1) As Addrees,

Substring(propertyaddress, Charindex(',', propertyaddress) +1, LEN(propertyaddress)) As Addrees

from [Portfolio Project]. dbo.nashvillehousing

ALTER TABLE Nashvillehousing 
Add  propertysplitAddress Nvarchar(255); 

Update nashvillehousing
SET propertysplitAddress =  Substring(propertyaddress, 1, Charindex(',', propertyaddress) -1)

ALTER TABLE nashvillehousing 
Add propertysplitCity Nvarchar(255); 

Update nashvillehousing
SET propertysplitAddress =  Substring(propertyaddress, Charindex(',', propertyaddress) +1, LEN(propertyaddress))


  Select * 
from [Portfolio Project]. dbo.nashvillehousing



  Select OwnerAddress
from [Portfolio Project]. dbo.nashvillehousing


Select 
PARSENAME(REPLACE( OwnerAddress,',','.'),3)
,PARSENAME(REPLACE( OwnerAddress,',','.'),2)
,PARSENAME(REPLACE( OwnerAddress,',','.'),1)

from [Portfolio Project]. dbo.nashvillehousing

ALTER TABLE Nashvillehousing 
Add  Ownerplitaddress Nvarchar(255); 

Update nashvillehousing
SET OwnerAddress = PARSENAME(REPLACE( OwnerAddress,',','.'),3)

ALTER TABLE nashvillehousing 
Add OwnerplitCity Nvarchar(255); 

Update nashvillehousing
SET OwnerplitCity = PARSENAME(REPLACE( OwnerAddress,',','.'),2)

ALTER TABLE nashvillehousing 
Add Ownersplitstate Nvarchar(255); 

Update nashvillehousing
SET Ownersplitstate = PARSENAME(REPLACE( OwnerAddress,',','.'),1)


  Select *
from [Portfolio Project]. dbo.nashvillehousing


Select Distinct(soldasvacant),count(soldasvacant)
from  [Portfolio Project]. dbo.nashvillehousing
group by soldasvacant
order by 2

Select soldasvacant
, case when soldasvacant = 'Y' then 'Yes'
  when soldasvacant =  'N' then 'No'
  ELSE soldasvacant
  END
from  [Portfolio Project]. dbo.nashvillehousing

--Remove Duplicats 

WITH rownumCTE as(
Select *, Row_number() over(
partition by parcelID,
             PROPERTYaddress,
			 saleprice,
			 saledate,
			 legalreference
			 order by 
			 uniqueID
			 ) row_num

From [Portfolio Project]. dbo.NashvilleHousing
--order by parcelID
) 
Select *
from rownumCTE
WHERE ROW_num > 1
order by propertyaddress


-- Dele unused columns

Select* 
From [Portfolio Project].dbo.NashvilleHousing

Alter table  [Portfolio Project].dbo.NashvilleHousing
drop column owneraddress, taxdistrict, propertyaddress

Alter table [Portfolio Project].dbo.NashvilleHousing
drop column saledate