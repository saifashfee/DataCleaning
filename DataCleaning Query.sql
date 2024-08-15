--Select * 
--from NashvilleHousing

--------------------------------------------------

--Select SaleDateConverted, CONVERT(Date, SaleDate)
--From NashvilleHousing

----Update
----NashvilleHousing
----Set SaleDate = CONVERT(Date, SaleDate)

--Alter Table NashvilleHousing /*adding new column*/
--Add SaleDateConverted Date;

--Update NashvilleHousing /*updating new column*/
--Set SaleDateConverted = Convert(Date, SaleDate)


--------------------------------------------------
/*Some Entries have NULL as permanent address, so Populating those: */

--Select *
--From NashvilleHousing
--Where PropertyAddress is null
--Order by ParcelID

--Making a copy of the table and joining it by ParcelID and UniqueID and checking those which have null as property address
--Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
--From NashvilleHousing a
--Join NashvilleHousing b
--	On a.ParcelID = b.ParcelID
--	And a.[UniqueID ] <> b.[UniqueID ]
--Where a.PropertyAddress is null

--copying addresses
--Update a
--Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
--From NashvilleHousing as a
--Join NashvilleHousing as b
--	on a.ParcelID = b.ParcelID
--	And a.[UniqueID ] <> b.[UniqueID ]
--Where a.PropertyAddress is null

--Select ISNULL(Expression,Value) /*is expression = NULL then Value will be returned*/


-------------------------------------------------------------------------


--Breaking out / formatting

--Select PropertyAddress
--From NashvilleHousing

--This is how to separate the strings
--Select
--SUBSTRING(PropertyAddress, 1 , CHARINDEX(',' , PropertyAddress) -1) as Address /*searching in propertyAddress starting from index 1, then searching for comma (,) and stopping when finding comma, but we don't need comma at the end of the address so going back 1 place */
--, SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress) +1 , Len(PropertyAddress)) as Address /*for next column start from comma and end at length of the string*/
--From NashvilleHousing

--Adding splitted address to the table
/*Making column*/
--Alter Table NashvilleHousing
--Add PropertySplitAddress Nvarchar(255)
/*Updating column*/
--Update NashvilleHousing
--Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, Charindex(',',PropertyAddress) -1)

--Alter Table NashvilleHousing
--Add PropertySplitCity Nvarchar(255)

--Update NashvilleHousing
--Set PropertySplitCity = SUBSTRING(PropertyAddress, Charindex(',',PropertyAddress) +1, LEN(PropertyAddress))



--Now cleaning Owner's address

--Parsename only works with fullstops (.), so we replace commas with fullstop AND it works backwards 
--Select 
--PARSENAME(Replace(OwnerAddress, ',','.'), 3),
--PARSENAME(Replace(OwnerAddress, ',','.'), 2),
--PARSENAME(Replace(OwnerAddress, ',','.'), 1)
--From NashvilleHousing


--Alter Table NashvilleHousing
--Add OwnerSplitAddress Nvarchar(255)

--Update NashvilleHousing
--Set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress, ',','.'), 3)


--Alter Table NashvilleHousing
--Add OwnerSplitCity Nvarchar(255)

--Update NashvilleHousing
--Set OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',','.'), 2)

--Alter Table NashvilleHousing
--Add OwnerSplitState Nvarchar(255)

--Update NashvilleHousing
--Set OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',','.'), 1)

--Select * 
--From NashvilleHousing


--------------------------------------------------------------------------------

--Change Y to Yes and N to No in Sold as Vacant column

--Checking how many Y N Yes and No are there
--Select Distinct(SoldAsVacant), Count(SoldAsVacant)
--From NashvilleHousing 
--Group by SoldAsVacant
--Order by 2

--This is how we do it
--Select SoldAsVacant,
--Case When SoldAsVacant = 'Y' Then 'Yes'
--	 When SoldAsVacant = 'N' Then 'No'
--	 Else SoldAsVacant
--	 End
--From NashvilleHousing

--Updating Y to Yes and N to No
--Update NashvilleHousing
--Set SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
--						When SoldAsVacant = 'N' Then 'No'
--						Else SoldAsVacant
--						End


---------------------------------------------------------------


--Remove Duplicates

--With RowNumberCTE As (
--Select *,
--	ROW_NUMBER() Over ( /*Row_Number function assigns a number to the row in each partition in order to know the order in which they were sorted*/
--	Partition By ParcelID,
--				 PropertyAddress,
--				 SalePrice,
--				 SaleDate,
--				 LegalReference
--				 Order by UniqueID
--					) as row_num
--From NashvilleHousing
--Order by ParcelID
)

/*Checking the Duplicate rows*/
--Select *
--From RowNumberCTE
--Where row_num > 1
--Order by [UniqueID ]

/*Deleting the duplicate rows*/
--Delete
--From RowNumberCTE
--Where row_num > 1


-------------------------------------------------------------------

--Deleting Unused Columns
--Select * 
--From NashvilleHousing


--Alter Table NashvilleHousing
--Drop Column OwnerAddress, TaxDistrict, PropertyAddress

--Alter Table NashvilleHousing
--Drop Column SaleDate






