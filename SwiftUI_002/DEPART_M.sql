-- Table: api."DEPART_M"

-- DROP TABLE api."DEPART_M";

CREATE TABLE api."DEPART_M"
(
    "distCode" character(6) COLLATE pg_catalog."default" NOT NULL,
    "distName" character varying(40) COLLATE pg_catalog."default" NOT NULL,
    "createdDate" date NOT NULL,
    "updatedDate" date NOT NULL,
    "updatedPgId" character varying(30) COLLATE pg_catalog."default" NOT NULL,
    "modifyCount" integer NOT NULL,
    CONSTRAINT "DEPART_M_pkey" PRIMARY KEY ("distCode")
)

TABLESPACE pg_default;

ALTER TABLE api."DEPART_M"
    OWNER to "siemos.m";
COMMENT ON TABLE api."DEPART_M"
    IS '所属マスタ';