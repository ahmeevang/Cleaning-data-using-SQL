--Cleaning data using SQL--

SELECT *
FROM `portfolio-project-377901.Nashville.Nashville_Housing`;

SELECT SaleDate
FROM `portfolio-project-377901.Nashville.Nashville_Housing`;


--Populating addresses

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
FROM `portfolio-project-377901.Nashville.Nashville_Housing` a
JOIN `portfolio-project-377901.Nashville.Nashville_Housing` b
  ON a.ParcelID = b.ParcelID
  AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL;

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, IFNULL(a.PropertyAddress, b.PropertyAddress)
FROM `portfolio-project-377901.Nashville.Nashville_Housing` a
JOIN `portfolio-project-377901.Nashville.Nashville_Housing` b
  ON a.ParcelID = b.ParcelID
  AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL;

UPDATE a
SET PropertyAddress = IFNULL(a.PropertyAddress, b.PropertyAddress)
FROM `portfolio-project-377901.Nashville.Nashville_Housing` a
JOIN `portfolio-project-377901.Nashville.Nashville_Housing` b
  ON a.ParcelID = b.ParcelID
  AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL;


--Separating property addresses

SELECT
SPLIT(PropertyAddress, ',') [ordinal(1)] AS Address,
SPLIT(PropertyAddress, ',') [ordinal(2)] AS City
FROM `portfolio-project-377901.Nashville.Nashville_Housing`;

ALTER TABLE `portfolio-project-377901.Nashville.Nashville_Housing`
ADD COLUMN PropertySplitAddress STRING;

UPDATE `portfolio-project-377901.Nashville.Nashville_Housing`
SET PropertySplitAddress = SPLIT(PropertyAddress, ',') [ordinal(1)]
WHERE PropertyAddress like '%,%';

ALTER TABLE `portfolio-project-377901.Nashville.Nashville_Housing`
ADD COLUMN PropertySplitCity STRING;

UPDATE `portfolio-project-377901.Nashville.Nashville_Housing`
SET PropertySplitCity = SPLIT(PropertyAddress, ',') [ordinal(2)]
WHERE PropertyAddress like '%,%';


--Separating owner addresses

SELECT
SPLIT(OwnerAddress, ',') [ordinal(1)] AS Address,
SPLIT(OwnerAddress, ',') [ordinal(2)] AS City,
SPLIT(OwnerAddress, ',') [ordinal(3)] AS State
FROM `portfolio-project-377901.Nashville.Nashville_Housing`;

ALTER TABLE `portfolio-project-377901.Nashville.Nashville_Housing`
ADD COLUMN OwnerSplitAddress STRING;

UPDATE `portfolio-project-377901.Nashville.Nashville_Housing`
SET OwnerSplitAddress = SPLIT(OwnerAddress, ',') [ordinal(1)]
WHERE OwnerAddress like '%,%';

ALTER TABLE `portfolio-project-377901.Nashville.Nashville_Housing`
ADD COLUMN OwnerSplitCity STRING;

UPDATE `portfolio-project-377901.Nashville.Nashville_Housing`
SET OwnerSplitCity = SPLIT(OwnerAddress, ',') [ordinal(2)]
WHERE OwnerAddress like '%,%';

ALTER TABLE `portfolio-project-377901.Nashville.Nashville_Housing`
ADD COLUMN OwnerSplitState STRING;

UPDATE `portfolio-project-377901.Nashville.Nashville_Housing`
SET OwnerSplitState = SPLIT(OwnerAddress, ',') [ordinal(3)]
WHERE OwnerAddress like '%,%';


--Removing duplicates

WITH RowNumCTE AS(
SELECT *,
ROW_NUMBER() OVER (
  PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
  ORDER BY UniqueID
) row_num
FROM `portfolio-project-377901.Nashville.Nashville_Housing`
)

DELETE
FROM RowNumCTE
WHERE row_num > 1;


--Deleting unused columns

ALTER TABLE `portfolio-project-377901.Nashville.Nashville_Housing`
DROP COLUMN PropertyAddress;

ALTER TABLE `portfolio-project-377901.Nashville.Nashville_Housing`
DROP COLUMN OwnerAddress;
