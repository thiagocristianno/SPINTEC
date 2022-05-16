USE [Xclinic]
GO

/****** Object:  UserDefinedFunction [dbo].[FNC_GET_URL]    Script Date: 12/04/2022 09:23:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER FUNCTION [dbo].[FNC_GET_URL]
(
 @entry_point VARCHAR(500), 
 @host  VARCHAR(500), 
 @secret  VARCHAR(500),
 @accessionNumber  VARCHAR(500), 
 @studyInstanceUID  VARCHAR(500), 
 @seriesInstanceUID  VARCHAR(500)
)
RETURNS VARCHAR(500)
AS BEGIN

--SELECT CAST(Datediff(s, '1970-01-01', GETUTCDATE()) AS BIGINT)*1000

	if (@accessionNumber is null and @studyInstanceUID is null)
	begin
					return 'StudyInstanceUID/ACC is mandatory';
	end
				declare @payload varchar(500);
				declare @url varchar(500)
				set @url= @host + @entry_point;
 
				if (@accessionNumber is not null)
				begin
					set @payload = @accessionNumber;
					set @url = @url+'a='+@accessionNumber;
				end
				else if (@studyInstanceUID is not null)
				begin
					set @payload = @studyInstanceUID;
					set @url=@url+'s1=' + @studyInstanceUID;
				end
 
				-- Timestamp
				 declare @date as datetime;
				 set @date = getdate();
				set @date = DATEADD(day , 3 , @date )  

				declare @timestamp as bigint;

				set @timestamp = CAST(Datediff(s, '1970-01-01', @date) AS BIGINT)*1000;  --epoch on MILIseconds
				
				--set @timestamp = 1635447957;
			    --return @timestamp;

				set @timestamp = ROUND((@timestamp/1000), 0)+86400; --Math.round(timestamp / 1000) + 86400; //epoch on seconds
				
				set @payload=concat(@payload,@timestamp);
				set @url=@url+'&t='+cast(@timestamp as varchar(500));

				declare @hash varchar(500);
				declare @hmac varchar(1000);
				--set @hash = dbo.HMAC('SHA1',@secret, @payload);   --'' -- CryptoJS.HmacSHA1(payload, secret);

				DECLARE @key varbinary(max) = CAST(@secret AS varbinary(max));
				DECLARE @message varbinary(max) = CAST(@payload AS varbinary(max));
				
				set @hash=CONVERT(VARCHAR(1000), dbo.hmac('SHA1',@key,@message), 2);
				--return @hash;

				set @hmac = convert(varbinary(max),@hash) --'' --hash.toString(CryptoJS.enc.Hex);
				
				set @url=@url+'&h='+@hmac;
 
				if (@seriesInstanceUID is not null and len(@seriesInstanceUID) > 0)
				begin
					set @url=@url+'&s2='+@seriesInstanceUID+',';
				end

				set @url=@url+'&r=1';
 
				return @url;



END;

GO


