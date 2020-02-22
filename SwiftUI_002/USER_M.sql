-- Table: api."USER_M"

-- DROP TABLE api."USER_M";

CREATE TABLE api."USER_M"
(
    "userId" character(20) COLLATE pg_catalog."default" NOT NULL,
    "userName" character varying(40) COLLATE pg_catalog."default" NOT NULL,
    "distCode" character(6) COLLATE pg_catalog."default" NOT NULL,
    "createdDate" date NOT NULL DEFAULT now(),
    "updatedDate" date NOT NULL DEFAULT now(),
    "updatedPgId" character varying(30) COLLATE pg_catalog."default" NOT NULL,
    "modifyCount" integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    "userImage" bytea,
    CONSTRAINT "USER_M_pkey" PRIMARY KEY ("userId")
)

TABLESPACE pg_default;

ALTER TABLE api."USER_M"
    OWNER to "siemos.m";

GRANT ALL ON TABLE api."USER_M" TO "siemos.m";

GRANT ALL ON TABLE api."USER_M" TO web_anon;

COMMENT ON TABLE api."USER_M"
    IS '利用者マスタ';



///////2020 0214
create or replace view api.checkhstd_v
as
select
a.userimage,
a.userid,
a.username,
a.distname,
    to_char(b.indate::timestamp with time zone, 'YYYY/MM/DD HH24:MI:SS'::text) AS indate,
    b.lastoutflg,
case when b.indate <b.outdate then
    to_char(b.outdate::timestamp with time zone, 'YYYY/MM/DD HH24:MI:SS'::text)
      else '----/--/-- --:--:--'
      END as outdate
from
api.usermst a,api.checkhstd b
where a.userid = b.userid
//

create or replace view api.usermst_v
as
 SELECT a.userid,
    count(a.*) AS cnt
   FROM api.usermst a
  GROUP BY a.userid;



