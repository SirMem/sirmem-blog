-- -----------------------------------------------------
-- Blog Database Schema
-- Author: Sirmem
-- Version: 1.0 (Simplified, No User System)
-- -----------------------------------------------------

-- 创建数据库 (如果不存在)
-- 建议使用 utf8mb4 字符集以支持 emoji 等特殊字符
CREATE DATABASE IF NOT EXISTS `my_blog` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 使用该数据库
USE `my_blog`;

-- -----------------------------------------------------
-- Table `t_category` (分类表)
-- -----------------------------------------------------
DROP TABLE IF EXISTS `t_category`;

CREATE TABLE `t_category` (
                              `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '分类ID, 主键',
                              `name` VARCHAR(50) NOT NULL COMMENT '分类名称',
                              `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                              `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                              PRIMARY KEY (`id`),
                              UNIQUE INDEX `uk_category_name` (`name` ASC) VISIBLE COMMENT '分类名称唯一索引'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='文章分类表';


-- -----------------------------------------------------
-- Table `t_tag` (标签表)
-- -----------------------------------------------------
DROP TABLE IF EXISTS `t_tag`;

CREATE TABLE `t_tag` (
                         `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '标签ID, 主键',
                         `name` VARCHAR(50) NOT NULL COMMENT '标签名称',
                         `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                         `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                         PRIMARY KEY (`id`),
                         UNIQUE INDEX `uk_tag_name` (`name` ASC) VISIBLE COMMENT '标签名称唯一索引'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='文章标签表';


-- -----------------------------------------------------
-- Table `t_post` (文章表)
-- -----------------------------------------------------
DROP TABLE IF EXISTS `t_post`;

CREATE TABLE `t_post` (
                          `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '文章ID, 主键',
                          `title` VARCHAR(255) NOT NULL COMMENT '文章标题',
                          `summary` VARCHAR(1000) NULL DEFAULT NULL COMMENT '文章摘要',
                          `content` LONGTEXT NOT NULL COMMENT '文章正文内容 (Markdown或HTML)',
                          `cover_image` VARCHAR(255) NULL DEFAULT NULL COMMENT '文章封面图URL',
                          `status` TINYINT NOT NULL DEFAULT 0 COMMENT '文章状态 (0: 草稿, 1: 已发布)',
                          `category_id` BIGINT NULL DEFAULT NULL COMMENT '分类ID',
                          `published_at` DATETIME NULL DEFAULT NULL COMMENT '发布时间',
                          `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                          `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                          PRIMARY KEY (`id`),
                          INDEX `idx_post_category` (`category_id` ASC) VISIBLE,
                          CONSTRAINT `fk_post_category`
                              FOREIGN KEY (`category_id`)
                                  REFERENCES `t_category` (`id`)
                                  ON DELETE SET NULL  -- 如果分类被删除，文章的分类ID置为NULL，而不是删除文章
                                  ON UPDATE CASCADE   -- 如果分类ID更新，自动级联更新
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='文章信息表';


-- -----------------------------------------------------
-- Table `t_post_tag` (文章与标签关联表)
-- -----------------------------------------------------
DROP TABLE IF EXISTS `t_post_tag`;

CREATE TABLE `t_post_tag` (
                              `post_id` BIGINT NOT NULL COMMENT '文章ID',
                              `tag_id` BIGINT NOT NULL COMMENT '标签ID',
                              PRIMARY KEY (`post_id`, `tag_id`),
                              INDEX `idx_post_tag_post` (`post_id` ASC) VISIBLE,
                              INDEX `idx_post_tag_tag` (`tag_id` ASC) VISIBLE,
                              CONSTRAINT `fk_post_tag_post`
                                  FOREIGN KEY (`post_id`)
                                      REFERENCES `t_post` (`id`)
                                      ON DELETE CASCADE  -- 如果文章被删除，关联记录也直接删除
                                      ON UPDATE CASCADE,
                              CONSTRAINT `fk_post_tag_tag`
                                  FOREIGN KEY (`tag_id`)
                                      REFERENCES `t_tag` (`id`)
                                      ON DELETE CASCADE  -- 如果标签被删除，关联记录也直接删除
                                      ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='文章与标签的关联表 (多对多)';

