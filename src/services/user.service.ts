import { userRepository } from '../repositories/user.repository';
import { AppError } from '../utils/AppError';
import { UpdateUserInput } from '../validations/user.validation';

const sanitizeUser = (user: { id: string; name: string; email: string; createdAt: Date }) => ({
  id: user.id,
  name: user.name,
  email: user.email,
  createdAt: user.createdAt,
});

export const userService = {
  async getAll() {
    const users = await userRepository.findAll();
    return users.map(sanitizeUser);
  },

  async getById(id: string) {
    const user = await userRepository.findById(id);
    if (!user) {
      throw new AppError('User not found', 404);
    }
    return sanitizeUser(user);
  },

  async update(id: string, input: UpdateUserInput) {
    const user = await userRepository.findById(id);
    if (!user) {
      throw new AppError('User not found', 404);
    }

    const updated = await userRepository.update(id, input);
    return sanitizeUser(updated);
  },

  async remove(id: string) {
    const user = await userRepository.findById(id);
    if (!user) {
      throw new AppError('User not found', 404);
    }

    await userRepository.delete(id);
  },
};
