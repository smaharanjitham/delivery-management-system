import {
  Table,
  Column,
  Model,
  DataType,
  ForeignKey,
  BelongsTo,
} from 'sequelize-typescript';

import {User} from './user.model';

@Table({
  tableName: 'refresh_tokens',
  timestamps: false,
})
export class RefreshToken extends Model {
  @Column({
    type: DataType.INTEGER,
    primaryKey: true,
    autoIncrement: true,
  })
  id!: number;

  @ForeignKey(() => User)
  @Column({
    type: DataType.INTEGER,
    allowNull: false,
    references: {
      model: 'users',
      key: 'id',
    },
  })
  user_id!: number;

  @Column({
    type: DataType.TEXT,
    allowNull: false,
  })
  refresh_token!: string;

  @Column({
    type: DataType.DATE,
    allowNull: true,
  })
  expires_at?: Date;

  @Column({
    type: DataType.DATE,
    defaultValue: DataType.NOW,
  })
  created_at?: Date;

  @BelongsTo(() => User, {
    foreignKey: 'user_id',
    as: 'user',
  })
  user!: User;
}